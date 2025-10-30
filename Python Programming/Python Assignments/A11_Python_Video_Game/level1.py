import pygame

# Starter code written by David Johnson for CS 1400 University of Utah.
# Finished game authors:
# Zachary Fletcher

def pixel_collision(mask1, rect1, mask2, rect2):
    """
    Check if the non-transparent pixels of one mask contacts the non-transparent pixels of another.
    """
    offset_x = rect2[0] - rect1[0]
    offset_y = rect2[1] - rect1[1]
    # See if the two masks at the offset are overlapping.
    overlap = mask1.overlap(mask2, (offset_x, offset_y))
    return overlap != None

def level1():
    """
    This function runs Level 1, where the player must pull levers in the sequence to stop a moving wall.
    :return: True if the win condition is met, False if the lose condition is met.
    """
    # Initialize pygame
    pygame.init()

    map = pygame.image.load("assets/Level 1 Map.png")
    # Store window width and height in a tuple.
    map_size = map.get_size()
    map_rect = map.get_rect()
    map_width, map_height = map_size

    # create the window based on the map size
    screen = pygame.display.set_mode(map_size)
    map = map.convert_alpha()
    map_mask = pygame.mask.from_surface(map)

    # You must replace these images with your own.
    # Create the start button and vignette
    start = pygame.image.load("assets/start.png").convert_alpha()
    start_rect = start.get_rect()
    start_rect.center = (map_width // 2, map_height // 2)

    # Create the player data
    player = pygame.image.load("assets/explorer.png").convert_alpha()
    player = pygame.transform.smoothscale(player, (143 // 4, 276 // 4))
    player_rect = player.get_rect()
    player_rect.center = (117, 188)
    player_mask = pygame.mask.from_surface(player)

    # Create Crusher
    crusher = pygame.image.load("assets/crusher.png").convert_alpha()
    crusher_rect = crusher.get_rect()
    crusher_rect.center = (401, -250)
    crusher_mask = pygame.mask.from_surface(crusher)

    # create the levers:
    lever1 = pygame.image.load(("assets/lever1.png"))
    lever1 = pygame.transform.smoothscale(lever1, ( 330 // 9, 336 // 9))
    lever1_rect = lever1.get_rect()
    lever1_mask = pygame.mask.from_surface(lever1)
    lever1_rect.center = (75, 104)
    lever2 = pygame.image.load(("assets/lever2.png"))
    lever2 = pygame.transform.smoothscale(lever2, (330 // 9, 336 // 9))
    lever2_rect = lever2.get_rect()
    lever2_mask = pygame.mask.from_surface(lever2)
    lever2_rect.center = (19, 232)
    lever3 = pygame.image.load(("assets/lever3.png"))
    lever3 = pygame.transform.smoothscale(lever3, (330 // 9, 336 // 9))
    lever3_rect = lever3.get_rect()
    lever3_mask = pygame.mask.from_surface(lever3)
    lever3_rect.center = (65, 420)

    # Create the Stairs
    stairs = pygame.image.load("assets/small stairs.png").convert_alpha()
    stairs = pygame.transform.flip(stairs, True, False)
    stairs_rect = stairs.get_rect()
    stairs_rect.bottomright = (map_width,map_height) # Source code from pygames:
    # https://www.pygame.org/docs/ref/mouse.html?highlight=buttondown
    stairs_mask = pygame.mask.from_surface(stairs)

    # The frame tells which sprite frame to draw
    frame_count = 0

    # The clock helps us manage the frames per second of the animation
    clock = pygame.time.Clock()

    # The started variable records if the start color has been clicked and the level started
    start_game = False
    face_right = False
    crusher_speed = 2
    crush_counter = 0
    lever_sequence = []
    lever1_pressed = False
    lever2_pressed = False
    lever3_pressed = False
    # The is_alive variable records if anything bad has happened (off the path, touch guard, etc.)
    is_alive = True

    # This is the main game loop. In it, we must:
    # - check for events
    # - update the scene
    # - draw the scene
    while is_alive:
        # Check events by looping over the list of events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                is_alive = False
            # Starts the game with mouse click
            if event.type == pygame.MOUSEBUTTONDOWN:
                start_game = True

        # Update the game state in this region.
        move_x = 0
        move_y = 0
        movement = 7
        if start_game == True:
            # Position the player with keys # code provided by ChatGPT, altered for script.
            keys = pygame.key.get_pressed()
            # Move up
            if keys[pygame.K_w]:
                move_y = -movement
            # Move down
            if keys[pygame.K_s]:
                move_y = movement
            # Move left
            if keys[pygame.K_a]:
                move_x = -movement
                if not face_right:
                    face_right = True
                    player = pygame.transform.flip(player, True, False)
                    # Source code: https://www.pygame.org/docs/ref/transform.html?highlight=flip
            # Move right
            if keys[pygame.K_d]:
                move_x = movement
                if face_right:
                    face_right = False
                    player = pygame.transform.flip(player, True, False)
                    # Source code: https://www.pygame.org/docs/ref/transform.html?highlight=flip

            # Skip level # remove
            if keys[pygame.K_EQUALS]:
                return True

            # Crusher movement
            # Check crusher depth and move crusher.
            if crush_counter <= 215 and lever_sequence != [1,2,3]:
                crusher_rect.y += crusher_speed
                crush_counter += 1
            if lever_sequence == [1,2,3]:
                crusher_rect.y -= crusher_speed

        # Wall collision:    # Code Provide by ChatGPT.
        # Save old position
        old_x = player_rect.x
        old_y = player_rect.y
        # Block collisions with walls on X axis
        player_rect.x += move_x
        if pixel_collision(player_mask, player_rect, map_mask, map_rect):
            player_rect.x = old_x

        # Block collisions walls on Y axis
        player_rect.y += move_y
        if pixel_collision(player_mask, player_rect, map_mask, map_rect):
            player_rect.y = old_y

        # Check collision with crusher. Crusher kills if touched.
        if pixel_collision(player_mask, player_rect, crusher_mask, crusher_rect):
            return False

        # Check collision with levers:
        #lever 1
        if pixel_collision(player_mask, player_rect, lever1_mask, lever1_rect) and lever1_pressed == False:
            lever1_pressed = True
            lever_sequence.append(1)
            lever1 = pygame.transform.flip(lever1, True, False)

        #lever 2
        if pixel_collision(player_mask, player_rect, lever2_mask, lever2_rect) and lever2_pressed == False:
            lever2_pressed = True
            lever_sequence.append(2)
            lever2 = pygame.transform.flip(lever2, True, False)

        # lever 3
        if pixel_collision(player_mask, player_rect, lever3_mask, lever3_rect) and lever3_pressed == False:
            lever3_pressed = True
            lever_sequence.append(3)
            lever3 = pygame.transform.flip(lever3, True, False)

        # Check collision with stairs. Win if player touches stairs.
        if pixel_collision(player_mask, player_rect, stairs_mask, stairs_rect):
            return True

        #Screen boundary Check
        #   Source code provided by ChatGPT and altered for this script.
        player_rect.x = max(0, min(player_rect.x, map_width - player_rect.width))
        player_rect.y = max(0, min(player_rect.y, map_height - player_rect.height))

        # Draw game characters here.
        # Do not intermingle updates and drawing.
        # Do updates above and drawing below.
        # Draw the background
        screen.fill((201, 173, 106)) # This helps check if the image path is transparent
        screen.blit(map, map_rect)

        # draw the stairs
        screen.blit(stairs, stairs_rect)

        # draw the levers
        screen.blit(lever1, lever1_rect)
        screen.blit(lever2, lever2_rect)
        screen.blit(lever3, lever3_rect)

        # Draw the player character
        screen.blit(player, player_rect)

        # Draw the crushers
        screen.blit(crusher, crusher_rect)

        # Draw the start button over the entire first level.
        if not start_game:
            screen.blit(start, start_rect)

        # Every time through the loop, increase the frame count.
        frame_count += 1

        # Bring drawn changes to the front
        pygame.display.update()

        # This tries to force the loop to run at 30 fps
        clock.tick(30)
