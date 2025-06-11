from pathlib import Path
from PIL import Image

def trim_transparency(img: Image.Image) -> Image.Image:
    # Ensure we have an alpha channel
    if img.mode != "RGBA":
        img = img.convert("RGBA")
    # Find the minimal bounding box of non-transparent pixels
    bbox = img.getchannel("A").getbbox()
    # Crop to that box (or return original if fully transparent)
    return img.crop(bbox) if bbox else img

def batch_trim_recursive(src_root: str, dst_root: str, pattern: str = "*.png"):
    """
    Recursively trims all images matching `pattern` under `src_root`,
    saving results under `dst_root` with the same subdirectory layout.
    """
    src_root = Path(src_root)
    dst_root = Path(dst_root)
    for src_path in src_root.rglob(pattern):
        # Compute the corresponding output path
        rel_path = src_path.relative_to(src_root)
        dst_path = dst_root / rel_path
        dst_path.parent.mkdir(parents=True, exist_ok=True)

        # Open, trim, and save
        img = Image.open(src_path)
        trimmed = trim_transparency(img)
        trimmed.save(dst_path)
        print(f"Trimmed: {src_path} → {dst_path}")

if __name__ == "__main__":
    # Example usage:
    # Trim everything in "assets/raw_sprites" into "assets/trimmed_sprites"
    batch_trim_recursive(".", "trimmed_sprites")
