# Finished game author:
# Zachary Fletcher

import pygame

def pixel_collision(mask1, rect1, mask2, rect2):
    """
    Check if the non-transparent pixels of one mask contacts the non-transparent pixels of another.
    """
    offset_x = rect2[0] - rect1[0]
    offset_y = rect2[1] - rect1[1]
    # See if the two masks at the offset are overlapping.
    overlap = mask1.overlap(mask2, (offset_x, offset_y))
    return overlap != None

def level3():
        """
        This function runs Level 2, where the player must avoid traps in a maze of darkness.
        :return: True if the win condition is met, False if the lose condition is met.
        """
        # Initialize pygame
        pygame.init()

        map = pygame.image.load("assets/Level 3 Map.png")
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
        player_rect.center = (63, 551)
        player_mask = pygame.mask.from_surface(player)

        # Create the Stairs
        stairs = pygame.image.load("assets/small stairs.png").convert_alpha()
        stairs = pygame.transform.rotate(stairs, 270)
        stairs_rect = stairs.get_rect()
        stairs_rect.topright = (map_width, 0)
        stairs_mask = pygame.mask.from_surface(stairs)

        # Create darkness and torch effect
        darkness = pygame.image.load("assets/darkness.png").convert_alpha()
        darkness_rect = darkness.get_rect()
        darkness_rect.center = (map_width // 2, map_height // 2)

        # Create Torch
        torch = pygame.image.load("assets/bigtorchlit1.png").convert_alpha()
        torch = pygame.transform.smoothscale(torch, (32 // 2, 128 // 2))
        torch_rect = torch.get_rect()
        torch_mask = pygame.mask.from_surface(torch)
        torch_rect.center = (15, 495)

        # Create spikes
        spikes = pygame.image.load("assets/spikes.png").convert_alpha()
        spikes_rect = spikes.get_rect()
        spikes_mask = pygame.mask.from_surface(spikes)
        spikes_rect.center = (map_width // 2, map_height // 2)

        # The frame tells which sprite frame to draw
        frame_count = 0

        # The clock helps us manage the frames per second of the animation
        clock = pygame.time.Clock()

        # The started variable records if the start color has been clicked and the level started
        start_game = False
        face_right = False
        torch_found = False
        spike_interval = 2000 # every 3 seconds
        last_interval = 0
        spikes_on = True
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

        # Check collision with torch:
            if pixel_collision(player_mask,player_rect, torch_mask, torch_rect):
                torch_found = True

        # Check collision with spikes:
            if pixel_collision(player_mask, player_rect, spikes_mask, spikes_rect) and spikes_on:
                return False

            # Check collision with stairs. Win if player touches stairs.
            if pixel_collision(player_mask, player_rect, stairs_mask, stairs_rect):
                return True

            # toggle the spikes on and off every 2 seconds.
            current_time = pygame.time.get_ticks() # expression provided by ChatGPT
            if current_time - last_interval > spike_interval:
                spikes_on = not spikes_on
                last_interval = current_time

            # Screen boundary Check
            #   Source code provided by ChatGPT and altered for this script.
            player_rect.x = max(0, min(player_rect.x, map_width - player_rect.width))
            player_rect.y = max(0, min(player_rect.y, map_height - player_rect.height))

            # Draw game characters here.
            # Do not intermingle updates and drawing.
            # Do updates above and drawing below.

            # Draw the background
            screen.fill((201, 173, 106))
            screen.blit(map, map_rect)

            # Draw the stairs
            screen.blit(stairs, stairs_rect)

            # Draw the torch
            if not torch_found:
                screen.blit(torch, torch_rect)

            # Draw Spikes
            if spikes_on:
                screen.blit(spikes, spikes_rect)

            # Draw the player character
            screen.blit(player, player_rect)

            # fill screen with darkness # code provided by ChatGPT, altered for this script.
            darkness.fill((0, 0, 0))
            if not torch_found: # when torch is standing
                pygame.draw.circle(darkness, (0, 0, 0, 0), (15, 495), 120)
            if torch_found: # when torch is in hand
                pygame.draw.circle(darkness, (0,0,0,0), (player_rect.x, player_rect.y), 120)
            # for light near door
            pygame.draw.circle(darkness, (0, 0, 0, 0), (744, 70), 80)
            screen.blit(darkness, darkness_rect)

            # Draw the start button over the entire first level.
            if not start_game:
                screen.blit(start, start_rect)

            # Every time through the loop, increase the frame count.
            frame_count += 1

            # Bring drawn changes to the front
            pygame.display.update()

            # This tries to force the loop to run at 30 fps
            clock.tick(30)