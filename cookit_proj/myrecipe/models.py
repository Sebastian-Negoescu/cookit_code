from django.db import models
from django.contrib.auth.models import User
from django.utils.timezone import now

class Category(models.Model):
    """
    A model class describing category
    """

    name = models.CharField("Name", max_length=100)
    slug = models.SlugField(unique=True)
    description = models.TextField("Description", max_length=255, blank=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Category"
        verbose_name_plural = "Categories"


class Recipe(models.Model):
    """
    A model class describing the cookbook's recipe
    """

    ### DIFFICULTY OPTIONS ###
    DIFFICULTY_EASY = 1
    DIFFICULTY_MEDIUM = 2
    DIFFICULTY_HARD = 3
    DIFFICULTIES = (
        (DIFFICULTY_EASY, 'easy'),
        (DIFFICULTY_MEDIUM, 'medium'),
        (DIFFICULTY_HARD, 'hard')
    )
    title = models.CharField("Title", max_length=100)
    slug = models.SlugField(unique=True)
    category = models.ManyToManyField(Category, verbose_name="Category")
    ingredients = models.TextField("Ingredients", max_length=1000, help_text="One ingredient per line | example: 'ingredient_name : ingredient_quantity'")
    preparation = models.TextField("Preparation")
    time_for_preparation = models.IntegerField("Preparation time", help_text="In minutes", blank=True, null=True)
    number_of_portions = models.PositiveIntegerField("Number of portions")
    difficulty = models.SmallIntegerField("Difficulty", choices=DIFFICULTIES, default=DIFFICULTY_MEDIUM)
    author = models.ForeignKey(User, verbose_name="Author", on_delete=models.CASCADE) # Import User from django.contrib.auth.models before using it.
    date_created = models.DateTimeField(editable=False)
    date_updated = models.DateTimeField(editable=False)

    class Meta:
        verbose_name = "Recipe"
        verbose_name_plural = "Recipes"
        ordering = ['-date_created']

    # Show the Object's TITLE in the ADMIN Application instead of Object_id(#)
    def __str__(self):
        return self.title

    # Time values should NOT be editable => we make have them automatically populated && override the save method:
    def save(self, *args, **kwargs):
        if not self.id: # which basically means that we will populate the date_created ONLY when creating the recipe (because ID does not exist yet)
            self.date_created = now()
        self.date_updated = now()
        super(Recipe, self).save(*args, **kwargs)
