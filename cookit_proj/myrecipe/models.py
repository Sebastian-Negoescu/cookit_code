from django.db import models

# Create your models here.
class Recipe(models.Model):
    name = models.CharField(max_length=150)
    description = models.TextField(max_length=3000)


    def __str__(self):
        return f"{self.name}"

# TO DO: besides the Recipe/Retete model, add "ingrediente" as one field with list "items property" && "images" for various photos that are to be uploaded for representation