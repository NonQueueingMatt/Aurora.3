--
-- Add a new theme style field
-- 

ALTER TABLE `ss13_player_preferences`
	ADD COLUMN `darkmode_theme` TINYINT DEFAULT '0'