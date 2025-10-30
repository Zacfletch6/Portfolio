import pygame
from pygame.examples.cursors import image


def display_loss_screen():
    # Initialize pygame
    pygame.init()

    map = pygame.image.load("assets/jungle background.png")
    # Store window width and height in a tuple.
    map_size = map.get_size()
    map_rect = map.get_rect()
    map_width, map_height = map_size

    # create the window based on the map size
    screen = pygame.display.set_mode(map_size)
    map = map.convert_alpha()

    game_over = pygame.image.load("assets/game over.png").convert_alpha()
    game_over_rect = game_over.get_rect()
    game_over_rect.center = (map_width // 2, map_height // 2)

    frame_count = 0
    clock = pygame.time.Clock()
    not_clicked = True
    while not_clicked:
        # Check events by looping over the list of events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                not_clicked = False
            # Starts the game with mouse click
            if event.type == pygame.MOUSEBUTTONDOWN:
                not_clicked = False
        # Draw game over screen
        screen.blit(map, map_rect)
        screen.blit(game_over, game_over_rect)

        # Every time through the loop, increase the frame count.
        frame_count += 1
        # Bring drawn changes to the front
        pygame.display.update()
        # This tries to force the loop to run at 30 fps
        clock.tick(30)

def display_win_screen():
    # Initialize pygame
    pygame.init()

    map = pygame.image.load("assets/jungle background.png")
    # Store window width and height in a tuple.
    map_size = map.get_size()
    map_rect = map.get_rect()
    map_width, map_height = map_size

    # create the window based on the map size
    screen = pygame.display.set_mode(map_size)
    map = map.convert_alpha()

    you_win = pygame.image.load("assets/you win.png").convert_alpha()
    you_win = pygame.transform.smoothscale(you_win, (1472 // 4, 980 // 4))
    you_win_rect = you_win.get_rect()
    you_win_rect.center = (map_width // 2, map_height // 2)

    frame_count = 0
    clock = pygame.time.Clock()
    not_clicked = True
    while not_clicked:
        # Check events by looping over the list of events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                not_clicked = False
            # Starts the game with mouse click
            if event.type == pygame.MOUSEBUTTONDOWN:
                not_clicked = False
        # Draw game over screen
        screen.blit(map, map_rect)
        screen.blit(you_win, you_win_rect)

        # Every time through the loop, increase the frame count.
        frame_count += 1
        # Bring drawn changes to the front
        pygame.display.update()
        # This tries to force the loop to run at 30 fps
        clock.tick(30)