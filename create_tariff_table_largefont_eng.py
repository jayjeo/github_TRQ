import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib import font_manager

# Korean font setup (prefer installed fonts)
font_family = None
windows_font_path = r'C:\Windows\Fonts\malgun.ttf'
if os.path.exists(windows_font_path):
    font_manager.fontManager.addfont(windows_font_path)
    font_family = font_manager.FontProperties(fname=windows_font_path).get_name()

korean_candidates = ['Malgun Gothic', 'AppleGothic', 'NanumGothic', 'Noto Sans CJK KR', 'NanumSquare']
if font_family is None:
    installed_fonts = {f.name for f in font_manager.fontManager.ttflist}
    for font_name in korean_candidates:
        if font_name in installed_fonts:
            font_family = font_name
            break

plt.rcParams['font.family'] = font_family or 'DejaVu Sans'
# Use the Unicode minus sign
plt.rcParams['axes.unicode_minus'] = False

# Korean-to-English item-name mapping (Title Case for display)
item_name_mapping = {
    '건고추': 'Dried Red Pepper',
    '고구마': 'Sweet Potato',
    '깻잎': 'Perilla Leaf',
    '녹두': 'Mung Bean',
    '느타리버섯': 'Oyster Mushroom',
    '당근': 'Carrot',
    '대파': 'Green Onion',
    '땅콩': 'Peanut',
    '레몬': 'Lemon',
    '마늘': 'Garlic',
    '망고': 'Mango',
    '멜론': 'Melon',
    '무': 'Radish',
    '미나리': 'Water Dropwort',
    '바나나': 'Banana',
    '방울토마토': 'Cherry Tomato',
    '배': 'Pear',
    '배추': 'Napa Cabbage',
    '붉은고추': 'Red Pepper',
    '사과': 'Apple',
    '상추': 'Lettuce',
    '새송이버섯': 'King Oyster Mushroom',
    '생강': 'Ginger',
    '수박': 'Watermelon',
    '시금치': 'Spinach',
    '아보카도': 'Avocado',
    '양배추': 'Cabbage',
    '양파': 'Onion',
    '얼갈이배추': 'Young Napa Cabbage',
    '열무': 'Young Summer Radish',
    '오이': 'Cucumber',
    '쪽파': 'Scallion',
    '참깨': 'Sesame',
    '참다래': 'Kiwifruit',
    '체리': 'Cherry',
    '콩': 'Bean',
    '토마토': 'Tomato',
    '파인애플': 'Pineapple',
    '파프리카': 'Bell Pepper',
    '팥': 'Adzuki Bean',
    '포도': 'Grape',
    '풋고추': 'Green Pepper',
    '피망': 'Sweet Pepper',
    '호박': 'Squash',
}

# Read the data
df = pd.read_stata('t3.dta')

# Item order (11 items excluding grapes, Korean, top to bottom)
item_order_kr = ['배추', '양배추', '무', '당근', '양파', '대파', '망고', '참다래', '바나나', '아보카도', '파인애플']
# Convert to English
item_order = [item_name_mapping[item] for item in item_order_kr]

# Convert the item names in the data to English
df['q_item_eng'] = df['q_item'].map(item_name_mapping)

# Pivot the data (item x date)
pivot_df = df.pivot(index='q_item_eng', columns='time', values='TRQD')

# Sort by item order
pivot_df = pivot_df.reindex(item_order)

# Sort by date
pivot_df = pivot_df.sort_index(axis=1)

# Group dates by year
dates = pivot_df.columns.tolist()
years = sorted(set([d[:4] for d in dates]))
date_info = [pd.to_datetime(d) for d in dates]

# Layout settings
DPI = 300
n_cols = len(dates)
n_rows = len(item_order)

# Item-name column settings
ITEM_COL_PIXELS = 300  # item column width (px) - widened because English names are longer
DATA_PIXEL_WIDTH = 1546  # data area width (px) - reduced to 80% (1933 * 0.8)
TARGET_PIXEL_WIDTH = ITEM_COL_PIXELS + DATA_PIXEL_WIDTH
TARGET_PIXEL_HEIGHT = 950  # row height base for 11 items (grapes excluded)

# Unit conversion: pixels to axis units
ITEM_COL_WIDTH = ITEM_COL_PIXELS / DATA_PIXEL_WIDTH * n_cols
COL_OFFSET = ITEM_COL_WIDTH

fig_width = TARGET_PIXEL_WIDTH / DPI
fig_height = TARGET_PIXEL_HEIGHT / DPI

# Use add_axes to control the margins directly
fig = plt.figure(figsize=(fig_width, fig_height), dpi=DPI)
ax = fig.add_axes([0.05, 0.05, 0.93, 0.88])  # left, bottom, width, height (fractions)
ax.set_xlim(0, COL_OFFSET + n_cols)
# ylim is set after ROW_HEIGHT is defined
ax.set_aspect('auto')
ax.axis('off')

# Title row height
title_y = n_rows + 1.5

# Draw the year headers
year_positions = {}
for year in years:
    year_dates = [d for d in dates if d.startswith(year)]
    start_idx = dates.index(year_dates[0])
    end_idx = dates.index(year_dates[-1])
    start_x = COL_OFFSET + start_idx
    end_x = COL_OFFSET + end_idx + 1
    mid_pos = COL_OFFSET + (start_idx + end_idx + 1) / 2
    year_positions[year] = (start_x, end_x, mid_pos)

    # Year text (centered later, after YEAR_HEADER_HEIGHT is defined)
    pass  # placeholder

# Compute month spans
month_spans = []
start_idx = 0
current_ym = (date_info[0].year, date_info[0].month)
for idx, ts in enumerate(date_info):
    ym = (ts.year, ts.month)
    if ym != current_ym:
        month_spans.append((current_ym[0], current_ym[1], start_idx, idx - 1))
        start_idx = idx
        current_ym = ym
month_spans.append((current_ym[0], current_ym[1], start_idx, len(date_info) - 1))

# Row heights
ROW_HEIGHT = 1.56  # item row height x1.56 (1.3 * 1.2)

# Header heights (x1.7 for the text size, then scaled to 90%)
MONTH_HEADER_HEIGHT = 0.6 * 1.6 * 1.7 * 0.9  # 1.4688
YEAR_HEADER_HEIGHT = 0.6 * 1.6 * 1.7 * 0.9  # 1.4688
TOTAL_HEADER_HEIGHT = MONTH_HEADER_HEIGHT + YEAR_HEADER_HEIGHT  # 2.9376

# Total height accounting for ROW_HEIGHT
total_height_with_headers = n_rows * ROW_HEIGHT + TOTAL_HEADER_HEIGHT
ax.set_ylim(0, total_height_with_headers)  # align the table's top/bottom exactly with the axes spines

# Month header boxes and month labels
total_rows_height = n_rows * ROW_HEIGHT
for year, month, start, end in month_spans:
    x0 = COL_OFFSET + start
    width = end - start + 1
    rect = mpatches.Rectangle((x0, total_rows_height), width, MONTH_HEADER_HEIGHT,
                              linewidth=0.4, edgecolor='black',
                              facecolor='white', fill=False, zorder=1)
    ax.add_patch(rect)
    # Month text - small offset to correct the Korean-font baseline
    ax.text(x0 + width / 2, total_rows_height + MONTH_HEADER_HEIGHT / 2 - 0.05, f"{month}",
            ha='center', va='center', fontsize=8.5, weight='normal')  # 5 * 1.7 = 8.5

# Item-name column (separate column boxes) - fill and borders
item_text_x = ITEM_COL_WIDTH / 2  # center the item names

for i, item in enumerate(item_order):
    row_y = (n_rows - i - 1) * ROW_HEIGHT
    # Item-name cell background - darker gray to separate it from the data columns
    rect = mpatches.Rectangle((0, row_y), ITEM_COL_WIDTH, ROW_HEIGHT,
                               linewidth=0,
                               edgecolor='none',
                               facecolor='#d0d0d0',  # darker gray background
                               fill=True,
                               zorder=2)
    ax.add_patch(rect)
    # Item-name text - small offset to correct the Korean-font baseline
    ax.text(item_text_x, row_y + ROW_HEIGHT / 2 - 0.05, item,
            ha='center', va='center',
            fontsize=10.2, weight='normal', zorder=5)  # 6 * 1.7 = 10.2

# Draw the data cells (color only, no 0/1 digits; no column separators)
for i, item in enumerate(item_order):
    row_y = (n_rows - i - 1) * ROW_HEIGHT
    for j, date in enumerate(dates):
        col_x = COL_OFFSET + j
        value = pivot_df.loc[item, date]

        if pd.isna(value) or value == 0:
            color = 'white'
        else:
            color = '#757575'  # slightly lighter gray

        rect = mpatches.Rectangle(
            (col_x, row_y), 1, ROW_HEIGHT,
            linewidth=0,
            edgecolor='none',
            facecolor=color,
            zorder=1  # draw below the item-name column
        )
        ax.add_patch(rect)

# Item-name column header area (blank) - darker gray background
item_header_rect = mpatches.Rectangle((0, total_rows_height), ITEM_COL_WIDTH, TOTAL_HEADER_HEIGHT,
                                       linewidth=0,
                                       edgecolor='none',
                                       facecolor='#d0d0d0',  # darker gray background
                                       fill=True)
ax.add_patch(item_header_rect)

# Outer frame around the whole table
# Outer frame: four separate lines; left/right thin (same as normal), top/bottom slightly thicker.
# clip_on=False + savefig(bbox_inches=None) + PIL autocrop keeps the border lines fully rendered instead of half-cropped
_frameW = COL_OFFSET + n_cols
_frameH = total_rows_height + TOTAL_HEADER_HEIGHT
FRAME_LW_SIDE = 0.6  # left/right (thin, same as normal borders)
FRAME_LW_TB = 1.0    # top/bottom (slightly thicker)
ax.plot([0, 0], [0, _frameH], 'k-', linewidth=FRAME_LW_SIDE, zorder=10, clip_on=False)
ax.plot([_frameW, _frameW], [0, _frameH], 'k-', linewidth=FRAME_LW_SIDE, zorder=10, clip_on=False)
ax.plot([0, _frameW], [_frameH, _frameH], 'k-', linewidth=FRAME_LW_TB, zorder=10, clip_on=False)
ax.plot([0, _frameW], [0, 0], 'k-', linewidth=FRAME_LW_TB, zorder=10, clip_on=False)

# Year border boxes
for year in years:
    start_x, end_x, mid_pos = year_positions[year]
    width = end_x - start_x
    # Year header box (above the month header)
    rect = mpatches.Rectangle((start_x, total_rows_height + MONTH_HEADER_HEIGHT), width, YEAR_HEADER_HEIGHT,
                              linewidth=0.4, edgecolor='black',
                              facecolor='white', fill=False, zorder=1)
    ax.add_patch(rect)
    # Year text - small offset to correct the Korean-font baseline
    ax.text(mid_pos, total_rows_height + MONTH_HEADER_HEIGHT + YEAR_HEADER_HEIGHT / 2 - 0.05, year,
            ha='center', va='center', fontsize=11.9, weight='normal')  # 7 * 1.7 = 11.9

# Month separators (vertical, body only - avoid the header text area)
for year, month, start, end in month_spans:
    boundary_x = COL_OFFSET + start
    ax.plot([boundary_x, boundary_x], [0, total_rows_height], 'k-', linewidth=0.4, zorder=3)

# Item-name column borders
# Left border
ax.plot([0, 0], [0, total_rows_height], 'k-', linewidth=0.6, zorder=3)
# Right border (separator against the data columns)
ax.plot([ITEM_COL_WIDTH, ITEM_COL_WIDTH], [0, total_rows_height + TOTAL_HEADER_HEIGHT], 'k-', linewidth=0.6, zorder=3)
# Item-name column top/bottom borders
ax.plot([0, ITEM_COL_WIDTH], [0, 0], 'k-', linewidth=0.6, zorder=3)
ax.plot([0, ITEM_COL_WIDTH], [total_rows_height, total_rows_height], 'k-', linewidth=0.6, zorder=3)
# Horizontal separators inside the item-name column (between items)
for i in range(0, n_rows + 1):
    y = i * ROW_HEIGHT
    ax.plot([0, ITEM_COL_WIDTH], [y, y], 'k-', linewidth=0.4, zorder=3)

# Horizontal separators for the data columns only (item-name column excluded)
for i in range(0, n_rows + 1):
    y = i * ROW_HEIGHT
    ax.plot([COL_OFFSET, COL_OFFSET + n_cols], [y, y], 'k-', linewidth=0.4, zorder=3)

plt.savefig(
    '할당관세적용표_eng.png',
    dpi=DPI,
    bbox_inches=None,
    pad_inches=0,
    facecolor='white',
    edgecolor='none'
)
plt.close()
# Precise margin removal (autocrop): save the full figure, then crop at the boundary between the white background and the content (including the outer frame)
# -> avoids tight-crop halving the border lines; preserves full border thickness on all four sides
from PIL import Image, ImageChops
_fn = '할당관세적용표_eng.png'
_img = Image.open(_fn).convert('RGB')
_bbox = ImageChops.difference(_img, Image.new('RGB', _img.size, (255, 255, 255))).getbbox()
if _bbox:
    _img.crop(_bbox).save(_fn)
print("표가 성공적으로 생성되었습니다: 할당관세적용표_eng.png")
