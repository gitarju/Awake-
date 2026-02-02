from PIL import Image, ImageChops

def trim(im):
    bg = Image.new(im.mode, im.size, im.getpixel((0,0)))
    diff = ImageChops.difference(im, bg)
    diff = ImageChops.add(diff, diff, 2.0, -100)
    bbox = diff.getbbox()
    if bbox:
        return im.crop(bbox)
    return im

def process_icon():
    try:
        img = Image.open("assets/icon/original.png")
        img = img.convert("RGBA")
        
        # Trim based on top-left pixel color
        bg_color = img.getpixel((0, 0))
        center_pixel = img.getpixel((img.width // 2, img.height // 2))
        print(f"Background color detected: {bg_color}")
        print(f"Center pixel color: {center_pixel}")
        print(f"Image extrema: {img.getextrema()}")
        
        bg = Image.new("RGBA", img.size, bg_color)
        diff = ImageChops.difference(img, bg)
        print(f"Diff extrema: {diff.getextrema()}")
        # Convert to RGB to ensure alpha=0 doesn't hide color differences
        bbox = diff.convert("RGB").getbbox()
        
        if bbox:
            print(f"Original size: {img.size}")
            print(f"Cropping to: {bbox}")
            cropped = img.crop(bbox)
            cropped.save("assets/icon/icon.png")
            print("Saved trimmed icon to assets/icon/icon.png")
        else:
            print("No significant difference found (image might be solid color)")
            img.save("assets/icon/icon.png")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    process_icon()
