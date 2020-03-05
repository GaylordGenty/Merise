SELECT * FROM images;
SELECT * FROM realisations

/*
1)ALTER TABLE realisation ADD CONSTRAINT pk_rea PRIMARY KEY (id_rea)
2) ALTER TABLE images ADD CONSTRAINT pk_img PRIMARY KEY (id_img)


3)	ALTER TABLE img ADD CONSTRAINT nom_contrainte FOREIGN KEY (nom_colone) REFERENCES autre_table(nom_colone);
		ALTER TABLE img ADD CONSTRAINT nom_contrainte PRIMARY KEY (nom_colone);
		images (ID_img, url_img, nom_img, text_img)


4)	images (#ID_img, url_img, nom_img, text_img)
5)	ALTER TABLE realisation ADD CONSTRAINT fk_rea FOREIGN KEY (titre_rea) REFERENCES images(nom_img)


Donner dans ce cas la requête qui pour une réalisation données (« id_rea » fixée)
permet de trouver toutes les images associées…

6) SELECT id_rea FROM realisations where titre_rea = 'nom_rea' AND titre_rea = (SELECT nom_img FROM images)


7) 2) Donner la procédure stockée qui permet de savoir combien de fois une image est
		utilisée dans les différentes réalisations en fonction du nom de l’image (nom_img)

CREATE PROCEDURE count_img (@titre_rea varchar, @nom_img varchar)
AS BEGIN

	SELECT COUNT(*) FROM images where @titre_rea = @nom_img 

END


--CREATE UNIQUE INDEX rea_img ON realisations(titre_rea)
--CREATE UNIQUE INDEX img_rea ON images(nom_img);

--Alter table realisations ADD CONSTRAINT fk_rea FOREIGN KEY (titre_rea) REFERENCES images(nom_img)
*/