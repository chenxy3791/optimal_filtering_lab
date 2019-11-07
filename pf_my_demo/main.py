# ------------------------------------------------------------------------
# coding=utf-8
# ------------------------------------------------------------------------
#
#  Created by Martin J. Laubach on 2011-11-15
#  Refined and re-structured by chenxy on 2019-11-07
#
# ------------------------------------------------------------------------

from __future__ import absolute_import

import random
import math
import bisect

from utilities import *
from Robot     import *
from Maze      import *


# 0 - empty square
# 1 - occupied square
# 2 - occupied square with a beacon at each corner, detectable by the robot

# Smaller maze
maze_data = ( ( 2, 0, 1, 0, 0 ),
              ( 0, 0, 0, 0, 1 ),
              ( 1, 1, 1, 0, 0 ),
              ( 1, 0, 0, 0, 0 ),
              ( 0, 0, 2, 0, 1 ))

## maze_data = ( ( 1, 1, 0, 0, 2, 0, 0, 0, 0, 1 ),
##               ( 1, 2, 0, 0, 1, 1, 0, 0, 0, 0 ),
##               ( 0, 1, 1, 0, 0, 0, 0, 1, 0, 1 ),
##               ( 0, 0, 0, 0, 1, 0, 0, 1, 1, 2 ),
##               ( 1, 1, 0, 1, 1, 2, 0, 0, 1, 0 ),
##               ( 1, 1, 1, 0, 1, 1, 1, 0, 2, 0 ),
##               ( 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 ),
##               ( 1, 2, 0, 1, 1, 1, 1, 0, 0, 0 ),
##               ( 0, 0, 0, 0, 1, 0, 0, 0, 1, 0 ),
##               ( 0, 0, 1, 0, 0, 2, 1, 1, 1, 0 ))

# ------------------------------------------------------------------------
# Some utility functions

world = Maze(maze_data)
world.draw()

# initial distribution assigns each particle an equal probability
particles = Particle.create_random(PARTICLE_COUNT, world)
robbie = Robot(world)

while True:
    # Read robbie's sensor
    r_d = robbie.read_sensor(world)

    # Update particle weight according to how good every particle matches
    # robbie's sensor reading
    for p in particles:
        if world.is_free(*p.xy):
            p_d = p.read_sensor(world)
            p.w = w_gauss(r_d, p_d)
        else:
            p.w = 0

    # ---------- Try to find current best estimate for display ----------
    m_x, m_y, m_confident = compute_mean_point(particles, world)

    # ---------- Show current state ----------
    world.show_particles(particles)
    world.show_mean(m_x, m_y, m_confident)
    world.show_robot(robbie)

    # ---------- Shuffle particles ----------
    new_particles = []

    # Normalise weights
    nu = sum(p.w for p in particles)
    if nu:
        for p in particles:
            p.w = p.w / nu

    # create a weighted distribution, for fast picking
    dist = WeightedDistribution(particles)

    for _ in particles:
        p = dist.pick()
        if p is None:  # No pick b/c all totally improbable
            new_particle = Particle.create_random(1, world)[0]
        else:
            new_particle = Particle(p.x, p.y,
                    heading=robbie.h if ROBOT_HAS_COMPASS else p.h,
                    noisy=True)
        new_particles.append(new_particle)

    particles = new_particles

    # ---------- Move things ----------
    old_heading = robbie.h
    robbie.move(world)
    d_h = robbie.h - old_heading

    # Move particles according to my belief of movement (this may
    # be different than the real movement, but it's all I got)
    for p in particles:
        p.h += d_h # in case robot changed heading, swirl particle heading too
        p.advance_by(robbie.speed)
