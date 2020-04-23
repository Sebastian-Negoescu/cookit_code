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


# #encoding: utf-8
# from django.db import models
# from django.contrib.auth.models import User # import for Author field in Recipe Model
# from django.utils.timezone import now # import for date_created/updated in Recipe Model


# # Create your models here.
# class Category(models.Model):
#     """
#     A model class describing category
#     """

#     name = models.CharField(u'Name', max_length=100)
#     slug = models.SlugField(unique=True)
#     description = models.TextField(u'Description', blank=True)

#     class Meta:
#         verbose_name = u'Category'
#         verbose_name_plural = u'Categories'

#     def __unicode__(self):
#         return self.name

#     def __str__(self):
#         return self.name

# class Recipe(models.Model):
#     """
#     A model describing a cookbook recipe
#     """

#     title = models.CharField(u'Title', max_length=255)
#     slug = models.SlugField(unique=True)
#     ingredients = models.TextField(u'Ingredients', help_text=u'One ingredient per line | ingredient_name - ingredient_quantity')
#     preparation = models.TextField(u'Preparation')
#     time_for_preparation = models.IntegerField(u'Preparation time', help_text=u'In minutes', blank=True, null=True)
#     number_of_portions = models.PositiveIntegerField(u'Number of portions')
#     # difficulty = models.SmallIntegerField(u'Difficulty') # difficulty field initial format
#     category = models.ManyToManyField(Category, verbose_name=u'Categories')
#     author = models.ForeignKey(User, verbose_name=u'Author', on_delete=models.CASCADE) # Import User from django.contrib.auth.models before using it.
#     date_created = models.DateTimeField(editable=False)
#     date_updated = models.DateTimeField(editable=False)
#     # Creating the difficulty options - we want a list to select from, not enter a number
#     DIFFICULTY_EASY = 1
#     DIFFICULTY_MEDIUM = 2
#     DIFFICULTY_HARD = 3
#     DIFFICULTIES = (
#         (DIFFICULTY_EASY, u'easy'),
#         (DIFFICULTY_MEDIUM, u'medium'),
#         (DIFFICULTY_HARD, u'hard')
#     )
#     # Linking to the difficulty field in the after-format:
#     difficulty = models.SmallIntegerField(u'Difficulty', choices=DIFFICULTIES, default=DIFFICULTY_MEDIUM)

#     class Meta:
#         verbose_name = u'Recipe'
#         verbose_name_plural = u'Recipes'
#         ordering = ['-date_created'] #default ordering of the recipes

#     def __unicode__(self):
#         return self.title

#     def __str__(self):
#         return self.title
    
#     # Time values should NOT be editable => we make have them automatically populated && override the save method:
#     def save(self, *args, **kwargs):
#         if not self.id: # which basically means that we will populate the date_created ONLY when creating the recipe (because ID does not exist yet)
#             self.date_created = now()
#         self.date_updated = now()
#         super(Recipe, self).save(*args, **kwargs)