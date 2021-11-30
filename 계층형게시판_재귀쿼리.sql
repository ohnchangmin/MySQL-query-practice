CREATE TABLE `education`.`board` (
  `idx` INT NOT NULL AUTO_INCREMENT,
  `num` INT NULL,
  `title` VARCHAR(45) NULL,
  `content` TEXT NULL,
  `writer` VARCHAR(45) NULL,
  `reg_date` TIMESTAMP NULL,
  `views` INT NULL DEFAULT 0,
  `p_idx` INT NULL,
  `depth` INT NULL DEFAULT 0,
  PRIMARY KEY (`idx`));

WITH RECURSIVE CTS AS(
							SELECT 
									idx, 
									num, 
									title, 
									content, 
									writer,
									reg_date,
									views,
									p_idx, 
									depth,
									CAST(idx as CHAR(100)) lvl,
									idx as groupno
							FROM board
							WHERE p_idx IS NULL
							UNION ALL
							SELECT 
									b.idx, 
									b.num,
									b.title, 
									b.content,
									b.writer,
									b.reg_date,
									b.views,
									b.p_idx, 
									b.depth, 
									CONCAT(c.lvl, ",", b.idx) lvl,
									substring_index(c.lvl, ",", 1) as groupno
							FROM board b
							INNER JOIN CTS c
							ON b.p_idx = c.idx
							)

							SELECT 
									idx, 
									num, 
									CONCAT(REPEAT("[답글]", depth), title) as title, 
									content, 
									writer, 
									reg_date, 
									views, 
									p_idx, 
									depth, 
									lvl,
									groupno
							FROM cts
							ORDER BY groupno DESC, lvl
							LIMIT #{pageStart}, #{perPageNum}