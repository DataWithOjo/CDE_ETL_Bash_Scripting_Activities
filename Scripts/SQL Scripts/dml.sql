-- Handles the null record in the following column
UPDATE dev.orders
SET
    standard_qty = COALESCE(standard_qty::INTEGER, 0),
    gloss_qty    = COALESCE(gloss_qty::INTEGER, 0),
    poster_qty   = COALESCE(poster_qty::INTEGER, 0);