import turicreate as tc

# Use CPU
turicreate.config.set_num_gpus(0)

# Load the style and content images
styles = tc.load_images('Dataset/style/')
content = tc.load_images('Dataset/content/')

# Create a StyleTransfer model
model = tc.style_transfer.create(styles, content)

# Load some test images
test_images = tc.load_images('test/')

# Stylize the test images
stylized_images = model.stylize(test_images)

# Save the model for later use in Turi Create
model.save('image-styler.model')

# Export for use in Core ML
model.export_coreml('ImageStyler.mlmodel')