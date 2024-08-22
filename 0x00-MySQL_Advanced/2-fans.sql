-- Rank country origins of bands ordered by the number of (non-unique) fans
SELECT origin, nb_fans
FROM metal_bands
ORDER BY nb_fans DESC;
