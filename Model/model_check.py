import turicreate as tc

model = tc.load_model('image-styler.model')
test_images = tc.load_images('Dataset/test/')

stylized_images = model.stylize(test_images)
stylized_images.explore()