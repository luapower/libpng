--result of cpp png.h from libpng 1.6.37 (and no longjmp stuff)
local ffi = require'ffi'
ffi.cdef[[
typedef struct FILE FILE;
typedef int32_t __time32_t;

typedef FILE * png_FILE_p;

typedef const double * png_const_doublep;
typedef png_byte * * png_bytepp;
typedef char * * png_charpp;




typedef struct png_control *png_controlp;
enum {
	PNG_IMAGE_WARNING    = 1,
	PNG_IMAGE_ERROR      = 2,
};
typedef struct
{
   png_controlp opaque;
   png_uint_32 version;
   png_uint_32 width;
   png_uint_32 height;
   png_uint_32 format;
   png_uint_32 flags;
   png_uint_32 colormap_entries;
   png_uint_32 warning_or_error;
   char message[64];
} png_image, *png_imagep;
enum {
	PNG_FORMAT_FLAG_ALPHA = 0x01U,
	PNG_FORMAT_FLAG_COLOR = 0x02U,
	PNG_FORMAT_FLAG_LINEAR = 0x04U,
	PNG_FORMAT_FLAG_COLORMAP = 0x08U,
};
enum {
	PNG_FORMAT_FLAG_BGR  = 0x10U,
	PNG_FORMAT_FLAG_AFIRST = 0x20U,
	PNG_FORMAT_FLAG_ASSOCIATED_ALPHA = 0x40U,
};

enum {
	PNG_FORMAT_GRAY      = 0,
	PNG_FORMAT_GA        = PNG_FORMAT_FLAG_ALPHA,
	PNG_FORMAT_AG        = (PNG_FORMAT_GA|PNG_FORMAT_FLAG_AFIRST),
	PNG_FORMAT_RGB       = PNG_FORMAT_FLAG_COLOR,
	PNG_FORMAT_BGR       = (PNG_FORMAT_FLAG_COLOR|PNG_FORMAT_FLAG_BGR),
	PNG_FORMAT_RGBA      = (PNG_FORMAT_RGB|PNG_FORMAT_FLAG_ALPHA),
	PNG_FORMAT_ARGB      = (PNG_FORMAT_RGBA|PNG_FORMAT_FLAG_AFIRST),
	PNG_FORMAT_BGRA      = (PNG_FORMAT_BGR|PNG_FORMAT_FLAG_ALPHA),
	PNG_FORMAT_ABGR      = (PNG_FORMAT_BGRA|PNG_FORMAT_FLAG_AFIRST),
};

enum {
	PNG_FORMAT_LINEAR_Y  = PNG_FORMAT_FLAG_LINEAR,
	PNG_FORMAT_LINEAR_Y_ALPHA = (PNG_FORMAT_FLAG_LINEAR|PNG_FORMAT_FLAG_ALPHA),
	PNG_FORMAT_LINEAR_RGB = (PNG_FORMAT_FLAG_LINEAR|PNG_FORMAT_FLAG_COLOR),
	PNG_FORMAT_LINEAR_RGB_ALPHA = (PNG_FORMAT_FLAG_LINEAR|PNG_FORMAT_FLAG_COLOR|PNG_FORMAT_FLAG_ALPHA),
};







enum {
	PNG_FORMAT_RGB_COLORMAP = (PNG_FORMAT_RGB|PNG_FORMAT_FLAG_COLORMAP),
	PNG_FORMAT_BGR_COLORMAP = (PNG_FORMAT_BGR|PNG_FORMAT_FLAG_COLORMAP),
	PNG_FORMAT_RGBA_COLORMAP = (PNG_FORMAT_RGBA|PNG_FORMAT_FLAG_COLORMAP),
	PNG_FORMAT_ARGB_COLORMAP = (PNG_FORMAT_ARGB|PNG_FORMAT_FLAG_COLORMAP),
	PNG_FORMAT_BGRA_COLORMAP = (PNG_FORMAT_BGRA|PNG_FORMAT_FLAG_COLORMAP),
	PNG_FORMAT_ABGR_COLORMAP = (PNG_FORMAT_ABGR|PNG_FORMAT_FLAG_COLORMAP),
};
#define PNG_IMAGE_SAMPLE_CHANNELS(fmt) (((fmt)&(PNG_FORMAT_FLAG_COLOR|PNG_FORMAT_FLAG_ALPHA))+1)



#define PNG_IMAGE_SAMPLE_COMPONENT_SIZE(fmt) ((((fmt) & PNG_FORMAT_FLAG_LINEAR) >> 2)+1)





#define PNG_IMAGE_SAMPLE_SIZE(fmt) (PNG_IMAGE_SAMPLE_CHANNELS(fmt) * PNG_IMAGE_SAMPLE_COMPONENT_SIZE(fmt))






#define PNG_IMAGE_MAXIMUM_COLORMAP_COMPONENTS(fmt) (PNG_IMAGE_SAMPLE_CHANNELS(fmt) * 256)
#define PNG_IMAGE_PIXEL_(test,fmt) (((fmt)&PNG_FORMAT_FLAG_COLORMAP)?1:test(fmt))


#define PNG_IMAGE_PIXEL_CHANNELS(fmt) PNG_IMAGE_PIXEL_(PNG_IMAGE_SAMPLE_CHANNELS,fmt)





#define PNG_IMAGE_PIXEL_COMPONENT_SIZE(fmt) PNG_IMAGE_PIXEL_(PNG_IMAGE_SAMPLE_COMPONENT_SIZE,fmt)





#define PNG_IMAGE_PIXEL_SIZE(fmt) PNG_IMAGE_PIXEL_(PNG_IMAGE_SAMPLE_SIZE,fmt)



#define PNG_IMAGE_ROW_STRIDE(image) (PNG_IMAGE_PIXEL_CHANNELS((image).format) * (image).width)
#define PNG_IMAGE_BUFFER_SIZE(image,row_stride) (PNG_IMAGE_PIXEL_COMPONENT_SIZE((image).format)*(image).height*(row_stride))
#define PNG_IMAGE_SIZE(image) PNG_IMAGE_BUFFER_SIZE(image, PNG_IMAGE_ROW_STRIDE(image))





#define PNG_IMAGE_COLORMAP_SIZE(image) (PNG_IMAGE_SAMPLE_SIZE((image).format) * (image).colormap_entries)
enum {
	PNG_IMAGE_FLAG_COLORSPACE_NOT_sRGB = 0x01,
};




enum {
	PNG_IMAGE_FLAG_FAST  = 0x02,
	PNG_IMAGE_FLAG_16BIT_sRGB = 0x04,
};
int png_image_begin_read_from_file) (png_imagep image, const char *file_name)
                          ;




int png_image_begin_read_from_stdio) (png_imagep image, FILE* file)
               ;



int png_image_begin_read_from_memory) (png_imagep image, png_const_voidp memory, size_t size)
                                        ;


int png_image_finish_read) (png_imagep image, png_const_colorp background, void *buffer, png_int_32 row_stride, void *colormap)

                   ;
void png_image_free) (png_imagep image);
int png_image_write_to_file) (png_imagep image, const char *file, int convert_to_8bit, const void *buffer, png_int_32 row_stride, const void *colormap)

                                                ;


int png_image_write_to_stdio) (png_imagep image, FILE *file, int convert_to_8_bit, const void *buffer, png_int_32 row_stride, const void *colormap)

                         ;
int png_image_write_to_memory) (png_imagep image, void *memory, png_alloc_size_t * __restrict memory_bytes, int convert_to_8_bit, const void *buffer, png_int_32 row_stride, const void *colormap)

                                                                    ;
#define png_image_write_get_memory_size(image,size,convert_to_8_bit,buffer,row_stride,colormap) png_image_write_to_memory(&(image), 0, &(size), convert_to_8_bit, buffer, row_stride, colormap)
#define PNG_IMAGE_DATA_SIZE(image) (PNG_IMAGE_SIZE(image)+(image).height)
#define PNG_ZLIB_MAX_SIZE(b) ((b)+(((b)+7U)>>3)+(((b)+63U)>>6)+11U)
#define PNG_IMAGE_COMPRESSED_SIZE_MAX(image) PNG_ZLIB_MAX_SIZE((png_alloc_size_t)PNG_IMAGE_DATA_SIZE(image))



#define PNG_IMAGE_PNG_SIZE_MAX_(image,image_size) ((8U +25U +16U +44U +12U + (((image).format&PNG_FORMAT_FLAG_COLORMAP)? 12U+3U*(image).colormap_entries + (((image).format&PNG_FORMAT_FLAG_ALPHA)? 12U +(image).colormap_entries:0U):0U)+ 12U)+(12U*((image_size)/PNG_ZBUF_SIZE)) +(image_size))
#define PNG_IMAGE_PNG_SIZE_MAX(image) PNG_IMAGE_PNG_SIZE_MAX_(image, PNG_IMAGE_COMPRESSED_SIZE_MAX(image))
enum {
	PNG_MAXIMUM_INFLATE_WINDOW = 2,
	PNG_SKIP_sRGB_CHECK_PROFILE = 4,
};



enum {
	PNG_IGNORE_ADLER32   = 8,
};



enum {
	PNG_OPTION_NEXT      = 12,
};


enum {
	PNG_OPTION_UNSET     = 0,
	PNG_OPTION_INVALID   = 1,
	PNG_OPTION_OFF       = 2,
	PNG_OPTION_ON        = 3,
};

int png_set_option) (png_structrp png_ptr, int option, int onoff)
              ;

enum {
	PNG_API_RULE         = 0,
	PNG_DEFAULT_READ_MACROS = 1,
	PNG_GAMMA_THRESHOLD_FIXED = 5000,
	PNG_IDAT_READ_SIZE   = PNG_ZBUF_SIZE,
	PNG_INFLATE_BUF_SIZE = 1024,
	PNG_LINKAGE_API      = extern,
	PNG_LINKAGE_CALLBACK = extern,
	PNG_LINKAGE_DATA     = extern,
	PNG_LINKAGE_FUNCTION = extern,
	PNG_MAX_GAMMA_8      = 11,
	PNG_QUANTIZE_BLUE_BITS = 5,
	PNG_QUANTIZE_GREEN_BITS = 5,
	PNG_QUANTIZE_RED_BITS = 5,
	PNG_TEXT_Z_DEFAULT_COMPRESSION = (-1),
	PNG_TEXT_Z_DEFAULT_STRATEGY = 0,
	PNG_USER_CHUNK_CACHE_MAX = 1000,
	PNG_USER_CHUNK_MALLOC_MAX = 8000000,
	PNG_USER_HEIGHT_MAX  = 1000000,
	PNG_USER_WIDTH_MAX   = 1000000,
	PNG_ZBUF_SIZE        = 8192,
	PNG_ZLIB_VERNUM      = 0,
	PNG_Z_DEFAULT_COMPRESSION = (-1),
	PNG_Z_DEFAULT_NOFILTER_STRATEGY = 0,
	PNG_Z_DEFAULT_STRATEGY = 1,
	PNG_sCAL_PRECISION   = 5,
	PNG_sRGB_PROFILE_CHECKS = 2,
};


typedef unsigned char png_byte;
typedef short png_int_16;
typedef unsigned short png_uint_16;
typedef int png_int_32;
typedef unsigned int png_uint_32;
typedef size_t png_size_t;
typedef ptrdiff_t png_ptrdiff_t;
typedef size_t png_alloc_size_t;
typedef png_int_32 png_fixed_point;
typedef void * png_voidp;
typedef const void * png_const_voidp;
typedef png_byte * png_bytep;
typedef const png_byte * png_const_bytep;
typedef png_uint_32 * png_uint_32p;
typedef const png_uint_32 * png_const_uint_32p;
typedef png_int_32 * png_int_32p;
typedef const png_int_32 * png_const_int_32p;
typedef png_uint_16 * png_uint_16p;
typedef const png_uint_16 * png_const_uint_16p;
typedef png_int_16 * png_int_16p;
typedef const png_int_16 * png_const_int_16p;
typedef char * png_charp;
typedef const char * png_const_charp;
typedef png_fixed_point * png_fixed_point_p;
typedef const png_fixed_point * png_const_fixed_point_p;
typedef size_t * png_size_tp;
typedef const size_t * png_const_size_tp;


typedef struct png_struct_def png_struct;
typedef const png_struct * png_const_structp;
typedef png_struct * png_structp;
typedef png_struct * * png_structpp;
typedef struct png_info_def png_info;
typedef png_info * png_infop;
typedef const png_info * png_const_infop;
typedef png_info * * png_infopp;
typedef png_struct * __restrict png_structrp;
typedef const png_struct * __restrict png_const_structrp;
typedef png_info * __restrict png_inforp;
typedef const png_info * __restrict png_const_inforp;

typedef struct png_color_struct
{
   png_byte red;
   png_byte green;
   png_byte blue;
} png_color;
typedef png_color * png_colorp;
typedef const png_color * png_const_colorp;
typedef png_color * * png_colorpp;

typedef struct png_color_16_struct
{
   png_byte index;
   png_uint_16 red;
   png_uint_16 green;
   png_uint_16 blue;
   png_uint_16 gray;
} png_color_16;
typedef png_color_16 * png_color_16p;
typedef const png_color_16 * png_const_color_16p;
typedef png_color_16 * * png_color_16pp;

typedef struct png_color_8_struct
{
   png_byte red;
   png_byte green;
   png_byte blue;
   png_byte gray;
   png_byte alpha;
} png_color_8;
typedef png_color_8 * png_color_8p;
typedef const png_color_8 * png_const_color_8p;
typedef png_color_8 * * png_color_8pp;





typedef struct png_sPLT_entry_struct
{
   png_uint_16 red;
   png_uint_16 green;
   png_uint_16 blue;
   png_uint_16 alpha;
   png_uint_16 frequency;
} png_sPLT_entry;
typedef png_sPLT_entry * png_sPLT_entryp;
typedef const png_sPLT_entry * png_const_sPLT_entryp;
typedef png_sPLT_entry * * png_sPLT_entrypp;






typedef struct png_sPLT_struct
{
   png_charp name;
   png_byte depth;
   png_sPLT_entryp entries;
   png_int_32 nentries;
} png_sPLT_t;
typedef png_sPLT_t * png_sPLT_tp;
typedef const png_sPLT_t * png_const_sPLT_tp;
typedef png_sPLT_t * * png_sPLT_tpp;
typedef struct png_text_struct
{
   int compression;




   png_charp key;
   png_charp text;

   size_t text_length;
   size_t itxt_length;
   png_charp lang;

   png_charp lang_key;

} png_text;
typedef png_text * png_textp;
typedef const png_text * png_const_textp;
typedef png_text * * png_textpp;




enum {
	PNG_TEXT_COMPRESSION_NONE_WR = -3,
	PNG_TEXT_COMPRESSION_zTXt_WR = -2,
	PNG_TEXT_COMPRESSION_NONE = -1,
	PNG_TEXT_COMPRESSION_zTXt = 0,
	PNG_ITXT_COMPRESSION_NONE = 1,
	PNG_ITXT_COMPRESSION_zTXt = 2,
	PNG_TEXT_COMPRESSION_LAST = 3,
};







typedef struct png_time_struct
{
   png_uint_16 year;
   png_byte month;
   png_byte day;
   png_byte hour;
   png_byte minute;
   png_byte second;
} png_time;
typedef png_time * png_timep;
typedef const png_time * png_const_timep;
typedef png_time * * png_timepp;
typedef struct png_unknown_chunk_t
{
   png_byte name[5];
   png_byte *data;
   size_t size;







   png_byte location;
}
png_unknown_chunk;

typedef png_unknown_chunk * png_unknown_chunkp;
typedef const png_unknown_chunk * png_const_unknown_chunkp;
typedef png_unknown_chunk * * png_unknown_chunkpp;



enum {
	PNG_HAVE_IHDR        = 0x01,
	PNG_HAVE_PLTE        = 0x02,
	PNG_AFTER_IDAT       = 0x08,
};


enum {
	PNG_UINT_31_MAX      = ((png_uint_32)0x7fffffffL),
	PNG_UINT_32_MAX      = ((png_uint_32)(-1)),
	PNG_SIZE_MAX         = ((size_t)(-1)),
};




enum {
	PNG_FP_1             = 100000,
	PNG_FP_HALF          = 50000,
	PNG_FP_MAX           = ((png_fixed_point)0x7fffffffL),
	PNG_FP_MIN           = (-PNG_FP_MAX),
};



enum {
	PNG_COLOR_MASK_PALETTE = 1,
	PNG_COLOR_MASK_COLOR = 2,
	PNG_COLOR_MASK_ALPHA = 4,
};


enum {
	PNG_COLOR_TYPE_GRAY  = 0,
	PNG_COLOR_TYPE_PALETTE = (PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_PALETTE),
	PNG_COLOR_TYPE_RGB   = (PNG_COLOR_MASK_COLOR),
	PNG_COLOR_TYPE_RGB_ALPHA = (PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_ALPHA),
	PNG_COLOR_TYPE_GRAY_ALPHA = (PNG_COLOR_MASK_ALPHA),
};

enum {
	PNG_COLOR_TYPE_RGBA  = PNG_COLOR_TYPE_RGB_ALPHA,
	PNG_COLOR_TYPE_GA    = PNG_COLOR_TYPE_GRAY_ALPHA,
};


enum {
	PNG_COMPRESSION_TYPE_BASE = 0,
	PNG_COMPRESSION_TYPE_DEFAULT = PNG_COMPRESSION_TYPE_BASE,
};


enum {
	PNG_FILTER_TYPE_BASE = 0,
	PNG_INTRAPIXEL_DIFFERENCING = 64,
	PNG_FILTER_TYPE_DEFAULT = PNG_FILTER_TYPE_BASE,
};


enum {
	PNG_INTERLACE_NONE   = 0,
	PNG_INTERLACE_ADAM7  = 1,
	PNG_INTERLACE_LAST   = 2,
};


enum {
	PNG_OFFSET_PIXEL     = 0,
	PNG_OFFSET_MICROMETER = 1,
	PNG_OFFSET_LAST      = 2,
};


enum {
	PNG_EQUATION_LINEAR  = 0,
	PNG_EQUATION_BASE_E  = 1,
	PNG_EQUATION_ARBITRARY = 2,
	PNG_EQUATION_HYPERBOLIC = 3,
	PNG_EQUATION_LAST    = 4,
};


enum {
	PNG_SCALE_UNKNOWN    = 0,
	PNG_SCALE_METER      = 1,
	PNG_SCALE_RADIAN     = 2,
	PNG_SCALE_LAST       = 3,
};


enum {
	PNG_RESOLUTION_UNKNOWN = 0,
	PNG_RESOLUTION_METER = 1,
	PNG_RESOLUTION_LAST  = 2,
};


enum {
	PNG_sRGB_INTENT_PERCEPTUAL = 0,
	PNG_sRGB_INTENT_RELATIVE = 1,
	PNG_sRGB_INTENT_SATURATION = 2,
	PNG_sRGB_INTENT_ABSOLUTE = 3,
	PNG_sRGB_INTENT_LAST = 4,
};


enum {
	PNG_KEYWORD_MAX_LENGTH = 79,
};


enum {
	PNG_MAX_PALETTE_LENGTH = 256,
};






enum {
	PNG_INFO_gAMA        = 0x0001U,
	PNG_INFO_sBIT        = 0x0002U,
	PNG_INFO_cHRM        = 0x0004U,
	PNG_INFO_PLTE        = 0x0008U,
	PNG_INFO_tRNS        = 0x0010U,
	PNG_INFO_bKGD        = 0x0020U,
	PNG_INFO_hIST        = 0x0040U,
	PNG_INFO_pHYs        = 0x0080U,
	PNG_INFO_oFFs        = 0x0100U,
	PNG_INFO_tIME        = 0x0200U,
	PNG_INFO_pCAL        = 0x0400U,
	PNG_INFO_sRGB        = 0x0800U,
	PNG_INFO_iCCP        = 0x1000U,
	PNG_INFO_sPLT        = 0x2000U,
	PNG_INFO_sCAL        = 0x4000U,
	PNG_INFO_IDAT        = 0x8000U,
	PNG_INFO_eXIf        = 0x10000U,
};





typedef struct png_row_info_struct
{
   png_uint_32 width;
   size_t rowbytes;
   png_byte color_type;
   png_byte bit_depth;
   png_byte channels;
   png_byte pixel_depth;
} png_row_info;

typedef png_row_info * png_row_infop;
typedef png_row_info * * png_row_infopp;
typedef void *png_error_ptr) (png_structp, png_const_charp);
typedef void *png_rw_ptr) (png_structp, png_bytep, size_t);
typedef void *png_flush_ptr) (png_structp);
typedef void *png_read_status_ptr) (png_structp, png_uint_32, int)
         ;
typedef void *png_write_status_ptr) (png_structp, png_uint_32, int)
         ;


typedef void *png_progressive_info_ptr) (png_structp, png_infop);
typedef void *png_progressive_end_ptr) (png_structp, png_infop);
typedef void *png_progressive_row_ptr) (png_structp, png_bytep, png_uint_32, int)
                      ;




typedef void *png_user_transform_ptr) (png_structp, png_row_infop, png_bytep)
               ;



typedef int *png_user_chunk_ptr) (png_structp, png_unknown_chunkp)
                        ;
typedef void *png_longjmp_ptr) (jmp_buf, int);



enum {
	PNG_TRANSFORM_IDENTITY = 0x0000,
	PNG_TRANSFORM_STRIP_16 = 0x0001,
	PNG_TRANSFORM_STRIP_ALPHA = 0x0002,
	PNG_TRANSFORM_PACKING = 0x0004,
	PNG_TRANSFORM_PACKSWAP = 0x0008,
	PNG_TRANSFORM_EXPAND = 0x0010,
	PNG_TRANSFORM_INVERT_MONO = 0x0020,
	PNG_TRANSFORM_SHIFT  = 0x0040,
	PNG_TRANSFORM_BGR    = 0x0080,
	PNG_TRANSFORM_SWAP_ALPHA = 0x0100,
	PNG_TRANSFORM_SWAP_ENDIAN = 0x0200,
	PNG_TRANSFORM_INVERT_ALPHA = 0x0400,
	PNG_TRANSFORM_STRIP_FILLER = 0x0800,
};

enum {
	PNG_TRANSFORM_STRIP_FILLER_BEFORE = PNG_TRANSFORM_STRIP_FILLER,
	PNG_TRANSFORM_STRIP_FILLER_AFTER = 0x1000,
};

enum {
	PNG_TRANSFORM_GRAY_TO_RGB = 0x2000,
};

enum {
	PNG_TRANSFORM_EXPAND_16 = 0x4000,
};

enum {
	PNG_TRANSFORM_SCALE_16 = 0x8000,
};



enum {
	PNG_FLAG_MNG_EMPTY_PLTE = 0x01,
	PNG_FLAG_MNG_FILTER_64 = 0x04,
	PNG_ALL_MNG_FEATURES = 0x05,
};







typedef png_voidp *png_malloc_ptr) (png_structp, png_alloc_size_t)
                      ;
typedef void *png_free_ptr) (png_structp, png_voidp);
png_uint_32 png_access_version_number) (void);




void png_set_sig_bytes) (png_structrp png_ptr, int num_bytes);






int png_sig_cmp) (png_const_bytep sig, size_t start, size_t num_to_check)
                         ;




#define png_check_sig(sig,n) !png_sig_cmp((sig), 0, (n))


png_structp png_create_read_struct) (png_const_charp user_png_ver, png_voidp error_ptr, png_error_ptr error_fn, png_error_ptr warn_fn)


                  ;


png_structp png_create_write_struct) (png_const_charp user_png_ver, png_voidp error_ptr, png_error_ptr error_fn, png_error_ptr warn_fn)


                  ;

size_t png_get_compression_buffer_size) (png_const_structrp png_ptr)
                                 ;

void png_set_compression_buffer_size) (png_structrp png_ptr, size_t size)
                 ;
jmp_buf* png_set_longjmp_fn) (png_structrp png_ptr, png_longjmp_ptr longjmp_fn, size_t jmp_buf_size)
                                                     ;
#define png_jmpbuf(png_ptr) (*png_set_longjmp_fn((png_ptr), longjmp, (sizeof (jmp_buf))))
void png_longjmp) (png_const_structrp png_ptr, int val)
                 ;

png_structp png_create_read_struct_2) (png_const_charp user_png_ver, png_voidp error_ptr, png_error_ptr error_fn, png_error_ptr warn_fn, png_voidp mem_ptr, png_malloc_ptr malloc_fn, png_free_ptr free_fn)



                  ;
png_structp png_create_write_struct_2) (png_const_charp user_png_ver, png_voidp error_ptr, png_error_ptr error_fn, png_error_ptr warn_fn, png_voidp mem_ptr, png_malloc_ptr malloc_fn, png_free_ptr free_fn)



                  ;



void png_write_sig) (png_structrp png_ptr);


void png_write_chunk) (png_structrp png_ptr, png_const_bytep chunk_name, png_const_bytep data, size_t length)
                                                     ;


void png_write_chunk_start) (png_structrp png_ptr, png_const_bytep chunk_name, png_uint_32 length)
                                                    ;


void png_write_chunk_data) (png_structrp png_ptr, png_const_bytep data, size_t length)
                                         ;


void png_write_chunk_end) (png_structrp png_ptr);


png_infop png_create_info_struct) (png_const_structrp png_ptr)
                  ;





void png_write_info_before_PLTE) (png_structrp png_ptr, png_const_inforp info_ptr)
                                                      ;
void png_write_info) (png_structrp png_ptr, png_const_inforp info_ptr)
                                                      ;



void png_read_info) (png_structrp png_ptr, png_inforp info_ptr)
                                                ;

int png_convert_to_rfc1123_buffer) (char out[29], png_const_timep ptime)
                           ;




void png_convert_from_struct_tm) (png_timep ptime, const struct tm * ttime)
                             ;


void png_convert_from_time_t) (png_timep ptime, time_t ttime);




void png_set_expand) (png_structrp png_ptr);
void png_set_expand_gray_1_2_4_to_8) (png_structrp png_ptr);
void png_set_palette_to_rgb) (png_structrp png_ptr);
void png_set_tRNS_to_alpha) (png_structrp png_ptr);






void png_set_expand_16) (png_structrp png_ptr);




void png_set_bgr) (png_structrp png_ptr);




void png_set_gray_to_rgb) (png_structrp png_ptr);




enum {
	PNG_ERROR_ACTION_NONE = 1,
	PNG_ERROR_ACTION_WARN = 2,
	PNG_ERROR_ACTION_ERROR = 3,
	PNG_RGB_TO_GRAY_DEFAULT = (-1),
};

void png_set_rgb_to_gray) (png_structrp png_ptr, int error_action, double red, double green);

void png_set_rgb_to_gray_fixed) (png_structrp png_ptr, int error_action, png_fixed_point red, png_fixed_point green);


png_byte png_get_rgb_to_gray_status) (png_const_structrp png_ptr)
             ;



void png_build_grayscale_palette) (int bit_depth, png_colorp palette)
                        ;
enum {
	PNG_ALPHA_PNG        = 0,
	PNG_ALPHA_STANDARD   = 1,
	PNG_ALPHA_ASSOCIATED = 1,
	PNG_ALPHA_PREMULTIPLIED = 1,
	PNG_ALPHA_OPTIMIZED  = 2,
	PNG_ALPHA_BROKEN     = 3,
};

void png_set_alpha_mode) (png_structrp png_ptr, int mode, double output_gamma);

void png_set_alpha_mode_fixed) (png_structrp png_ptr, int mode, png_fixed_point output_gamma);







enum {
	PNG_DEFAULT_sRGB     = -1,
	PNG_GAMMA_MAC_18     = -2,
	PNG_GAMMA_sRGB       = 220000,
	PNG_GAMMA_LINEAR     = PNG_FP_1,
};
void png_set_strip_alpha) (png_structrp png_ptr);




void png_set_swap_alpha) (png_structrp png_ptr);




void png_set_invert_alpha) (png_structrp png_ptr);




void png_set_filler) (png_structrp png_ptr, png_uint_32 filler, int flags)
               ;

enum {
	PNG_FILLER_BEFORE    = 0,
	PNG_FILLER_AFTER     = 1,
};

void png_set_add_alpha) (png_structrp png_ptr, png_uint_32 filler, int flags)
                                   ;




void png_set_swap) (png_structrp png_ptr);




void png_set_packing) (png_structrp png_ptr);





void png_set_packswap) (png_structrp png_ptr);




void png_set_shift) (png_structrp png_ptr, png_const_color_8p true_bits)
               ;
int png_set_interlace_handling) (png_structrp png_ptr);




void png_set_invert_mono) (png_structrp png_ptr);
void png_set_background) (png_structrp png_ptr, png_const_color_16p background_color, int background_gamma_code, int need_expand, double background_gamma);


void png_set_background_fixed) (png_structrp png_ptr, png_const_color_16p background_color, int background_gamma_code, int need_expand, png_fixed_point background_gamma);




enum {
	PNG_BACKGROUND_GAMMA_UNKNOWN = 0,
	PNG_BACKGROUND_GAMMA_SCREEN = 1,
	PNG_BACKGROUND_GAMMA_FILE = 2,
	PNG_BACKGROUND_GAMMA_UNIQUE = 3,
};




void png_set_scale_16) (png_structrp png_ptr);




void png_set_strip_16) (png_structrp png_ptr);






void png_set_quantize) (png_structrp png_ptr, png_colorp palette, int num_palette, int maximum_colors, png_const_uint_16p histogram, int full_quantize)

                                                     ;






enum {
	PNG_GAMMA_THRESHOLD  = (PNG_GAMMA_THRESHOLD_FIXED*.00001),
};
void png_set_gamma) (png_structrp png_ptr, double screen_gamma, double override_file_gamma);

void png_set_gamma_fixed) (png_structrp png_ptr, png_fixed_point screen_gamma, png_fixed_point override_file_gamma);





void png_set_flush) (png_structrp png_ptr, int nrows);

void png_write_flush) (png_structrp png_ptr);



void png_start_read_image) (png_structrp png_ptr);


void png_read_update_info) (png_structrp png_ptr, png_inforp info_ptr)
                         ;



void png_read_rows) (png_structrp png_ptr, png_bytepp row, png_bytepp display_row, png_uint_32 num_rows)
                                                  ;




void png_read_row) (png_structrp png_ptr, png_bytep row, png_bytep display_row)
                           ;




void png_read_image) (png_structrp png_ptr, png_bytepp image);



void png_write_row) (png_structrp png_ptr, png_const_bytep row)
                         ;






void png_write_rows) (png_structrp png_ptr, png_bytepp row, png_uint_32 num_rows)
                          ;


void png_write_image) (png_structrp png_ptr, png_bytepp image);


void png_write_end) (png_structrp png_ptr, png_inforp info_ptr)
                         ;



void png_read_end) (png_structrp png_ptr, png_inforp info_ptr);



void png_destroy_info_struct) (png_const_structrp png_ptr, png_infopp info_ptr_ptr)
                             ;


void png_destroy_read_struct) (png_structpp png_ptr_ptr, png_infopp info_ptr_ptr, png_infopp end_info_ptr_ptr)
                                                          ;


void png_destroy_write_struct) (png_structpp png_ptr_ptr, png_infopp info_ptr_ptr)
                             ;


void png_set_crc_action) (png_structrp png_ptr, int crit_action, int ancil_action)
                      ;
enum {
	PNG_CRC_DEFAULT      = 0,
	PNG_CRC_ERROR_QUIT   = 1,
	PNG_CRC_WARN_DISCARD = 2,
	PNG_CRC_WARN_USE     = 3,
	PNG_CRC_QUIET_USE    = 4,
	PNG_CRC_NO_CHANGE    = 5,
};
void png_set_filter) (png_structrp png_ptr, int method, int filters)
                 ;







enum {
	PNG_NO_FILTERS       = 0x00,
	PNG_FILTER_NONE      = 0x08,
	PNG_FILTER_SUB       = 0x10,
	PNG_FILTER_UP        = 0x20,
	PNG_FILTER_AVG       = 0x40,
	PNG_FILTER_PAETH     = 0x80,
	PNG_FAST_FILTERS     = (PNG_FILTER_NONE | PNG_FILTER_SUB | PNG_FILTER_UP),
	PNG_ALL_FILTERS      = (PNG_FAST_FILTERS | PNG_FILTER_AVG | PNG_FILTER_PAETH),
};




enum {
	PNG_FILTER_VALUE_NONE = 0,
	PNG_FILTER_VALUE_SUB = 1,
	PNG_FILTER_VALUE_UP  = 2,
	PNG_FILTER_VALUE_AVG = 3,
	PNG_FILTER_VALUE_PAETH = 4,
	PNG_FILTER_VALUE_LAST = 5,
};



void png_set_filter_heuristics) (png_structrp png_ptr, int heuristic_method, int num_weights, png_const_doublep filter_weights, png_const_doublep filter_costs);


void png_set_filter_heuristics_fixed) (png_structrp png_ptr, int heuristic_method, int num_weights, png_const_fixed_point_p filter_weights, png_const_fixed_point_p filter_costs);






enum {
	PNG_FILTER_HEURISTIC_DEFAULT = 0,
	PNG_FILTER_HEURISTIC_UNWEIGHTED = 1,
	PNG_FILTER_HEURISTIC_WEIGHTED = 2,
	PNG_FILTER_HEURISTIC_LAST = 3,
};
void png_set_compression_level) (png_structrp png_ptr, int level)
               ;

void png_set_compression_mem_level) (png_structrp png_ptr, int mem_level)
                   ;

void png_set_compression_strategy) (png_structrp png_ptr, int strategy)
                  ;




void png_set_compression_window_bits) (png_structrp png_ptr, int window_bits)
                     ;

void png_set_compression_method) (png_structrp png_ptr, int method)
                ;




void png_set_text_compression_level) (png_structrp png_ptr, int level)
               ;

void png_set_text_compression_mem_level) (png_structrp png_ptr, int mem_level)
                   ;

void png_set_text_compression_strategy) (png_structrp png_ptr, int strategy)
                  ;




void png_set_text_compression_window_bits) (png_structrp png_ptr, int window_bits)
                                            ;

void png_set_text_compression_method) (png_structrp png_ptr, int method)
                ;
void png_init_io) (png_structrp png_ptr, png_FILE_p fp);
void png_set_error_fn) (png_structrp png_ptr, png_voidp error_ptr, png_error_ptr error_fn, png_error_ptr warning_fn)
                                                                           ;


png_voidp png_get_error_ptr) (png_const_structrp png_ptr);
void png_set_write_fn) (png_structrp png_ptr, png_voidp io_ptr, png_rw_ptr write_data_fn, png_flush_ptr output_flush_fn)
                                                             ;


void png_set_read_fn) (png_structrp png_ptr, png_voidp io_ptr, png_rw_ptr read_data_fn)
                             ;


png_voidp png_get_io_ptr) (png_const_structrp png_ptr);

void png_set_read_status_fn) (png_structrp png_ptr, png_read_status_ptr read_row_fn)
                                     ;

void png_set_write_status_fn) (png_structrp png_ptr, png_write_status_ptr write_row_fn)
                                       ;



void png_set_mem_fn) (png_structrp png_ptr, png_voidp mem_ptr, png_malloc_ptr malloc_fn, png_free_ptr free_fn)
                                                    ;

png_voidp png_get_mem_ptr) (png_const_structrp png_ptr);



void png_set_read_user_transform_fn) (png_structrp png_ptr, png_user_transform_ptr read_user_transform_fn)
                                                   ;



void png_set_write_user_transform_fn) (png_structrp png_ptr, png_user_transform_ptr write_user_transform_fn)
                                                    ;



void png_set_user_transform_info) (png_structrp png_ptr, png_voidp user_transform_ptr, int user_transform_depth, int user_transform_channels)

                                 ;

png_voidp png_get_user_transform_ptr) (png_const_structrp png_ptr)
                                 ;
png_uint_32 png_get_current_row_number) (png_const_structrp);
png_byte png_get_current_pass_number) (png_const_structrp);
void png_set_read_user_chunk_fn) (png_structrp png_ptr, png_voidp user_chunk_ptr, png_user_chunk_ptr read_user_chunk_fn)
                                                                     ;



png_voidp png_get_user_chunk_ptr) (png_const_structrp png_ptr);






void png_set_progressive_read_fn) (png_structrp png_ptr, png_voidp progressive_ptr, png_progressive_info_ptr info_fn, png_progressive_row_ptr row_fn, png_progressive_end_ptr end_fn)

                                                                    ;


png_voidp png_get_progressive_ptr) (png_const_structrp png_ptr)
                                 ;


void png_process_data) (png_structrp png_ptr, png_inforp info_ptr, png_bytep buffer, size_t buffer_size)
                                                               ;
size_t png_process_data_pause) (png_structrp, int save);







png_uint_32 png_process_data_skip) (png_structrp);






void png_progressive_combine_row) (png_const_structrp png_ptr, png_bytep old_row, png_const_bytep new_row)
                                                ;


png_voidp png_malloc) (png_const_structrp png_ptr, png_alloc_size_t size)
                                          ;

png_voidp png_calloc) (png_const_structrp png_ptr, png_alloc_size_t size)
                                          ;


png_voidp png_malloc_warn) (png_const_structrp png_ptr, png_alloc_size_t size)
                                          ;


void png_free) (png_const_structrp png_ptr, png_voidp ptr);


void png_free_data) (png_const_structrp png_ptr, png_inforp info_ptr, png_uint_32 free_me, int num)
                                                       ;
void png_data_freer) (png_const_structrp png_ptr, png_inforp info_ptr, int freer, png_uint_32 mask)
                                                      ;


enum {
	PNG_DESTROY_WILL_FREE_DATA = 1,
	PNG_SET_WILL_FREE_DATA = 1,
	PNG_USER_WILL_FREE_DATA = 2,
};

enum {
	PNG_FREE_HIST        = 0x0008U,
	PNG_FREE_ICCP        = 0x0010U,
	PNG_FREE_SPLT        = 0x0020U,
	PNG_FREE_ROWS        = 0x0040U,
	PNG_FREE_PCAL        = 0x0080U,
	PNG_FREE_SCAL        = 0x0100U,
};

enum {
	PNG_FREE_UNKN        = 0x0200U,
};


enum {
	PNG_FREE_PLTE        = 0x1000U,
	PNG_FREE_TRNS        = 0x2000U,
	PNG_FREE_TEXT        = 0x4000U,
	PNG_FREE_EXIF        = 0x8000U,
	PNG_FREE_ALL         = 0xffffU,
	PNG_FREE_MUL         = 0x4220U,
};


void png_error) (png_const_structrp png_ptr, png_const_charp error_message)
                                                 ;


void png_chunk_error) (png_const_structrp png_ptr, png_const_charp error_message)
                                                 ;
void png_warning) (png_const_structrp png_ptr, png_const_charp warning_message)
                                     ;


void png_chunk_warning) (png_const_structrp png_ptr, png_const_charp warning_message)
                                     ;
void png_benign_error) (png_const_structrp png_ptr, png_const_charp warning_message)
                                     ;



void png_chunk_benign_error) (png_const_structrp png_ptr, png_const_charp warning_message)
                                     ;


void png_set_benign_errors) (png_structrp png_ptr, int allowed)
                                        ;
png_uint_32 png_get_valid) (png_const_structrp png_ptr, png_const_inforp info_ptr, png_uint_32 flag)
                                                 ;


size_t png_get_rowbytes) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;





png_bytepp png_get_rows) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;




void png_set_rows) (png_const_structrp png_ptr, png_inforp info_ptr, png_bytepp row_pointers)
                                                  ;



png_byte png_get_channels) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;



png_uint_32 png_get_image_width) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;


png_uint_32 png_get_image_height) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;


png_byte png_get_bit_depth) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;


png_byte png_get_color_type) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;


png_byte png_get_filter_type) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;


png_byte png_get_interlace_type) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;


png_byte png_get_compression_type) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;


png_uint_32 png_get_pixels_per_meter) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;
png_uint_32 png_get_x_pixels_per_meter) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;
png_uint_32 png_get_y_pixels_per_meter) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;


float png_get_pixel_aspect_ratio) (png_const_structrp png_ptr, png_const_inforp info_ptr);

png_fixed_point png_get_pixel_aspect_ratio_fixed) (png_const_structrp png_ptr, png_const_inforp info_ptr);



png_int_32 png_get_x_offset_pixels) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;
png_int_32 png_get_y_offset_pixels) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;
png_int_32 png_get_x_offset_microns) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;
png_int_32 png_get_y_offset_microns) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;





png_const_bytep png_get_signature) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                               ;



png_uint_32 png_get_bKGD) (png_const_structrp png_ptr, png_inforp info_ptr, png_color_16p *background)
                                                    ;



void png_set_bKGD) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_color_16p background)
                                                         ;



png_uint_32 png_get_cHRM) (png_const_structrp png_ptr, png_const_inforp info_ptr, double *white_x, double *white_y, double *red_x, double *red_y, double *green_x, double *green_y, double *blue_x, double *blue_y);



png_uint_32 png_get_cHRM_XYZ) (png_const_structrp png_ptr, png_const_inforp info_ptr, double *red_X, double *red_Y, double *red_Z, double *green_X, double *green_Y, double *green_Z, double *blue_X, double *blue_Y, double *blue_Z);



png_uint_32 png_get_cHRM_fixed) (png_const_structrp png_ptr, png_const_inforp info_ptr, png_fixed_point *int_white_x, png_fixed_point *int_white_y, png_fixed_point *int_red_x, png_fixed_point *int_red_y, png_fixed_point *int_green_x, png_fixed_point *int_green_y, png_fixed_point *int_blue_x, png_fixed_point *int_blue_y);





png_uint_32 png_get_cHRM_XYZ_fixed) (png_const_structrp png_ptr, png_const_inforp info_ptr, png_fixed_point *int_red_X, png_fixed_point *int_red_Y, png_fixed_point *int_red_Z, png_fixed_point *int_green_X, png_fixed_point *int_green_Y, png_fixed_point *int_green_Z, png_fixed_point *int_blue_X, png_fixed_point *int_blue_Y, png_fixed_point *int_blue_Z);
void png_set_cHRM) (png_const_structrp png_ptr, png_inforp info_ptr, double white_x, double white_y, double red_x, double red_y, double green_x, double green_y, double blue_x, double blue_y);



void png_set_cHRM_XYZ) (png_const_structrp png_ptr, png_inforp info_ptr, double red_X, double red_Y, double red_Z, double green_X, double green_Y, double green_Z, double blue_X, double blue_Y, double blue_Z);



void png_set_cHRM_fixed) (png_const_structrp png_ptr, png_inforp info_ptr, png_fixed_point int_white_x, png_fixed_point int_white_y, png_fixed_point int_red_x, png_fixed_point int_red_y, png_fixed_point int_green_x, png_fixed_point int_green_y, png_fixed_point int_blue_x, png_fixed_point int_blue_y);





void png_set_cHRM_XYZ_fixed) (png_const_structrp png_ptr, png_inforp info_ptr, png_fixed_point int_red_X, png_fixed_point int_red_Y, png_fixed_point int_red_Z, png_fixed_point int_green_X, png_fixed_point int_green_Y, png_fixed_point int_green_Z, png_fixed_point int_blue_X, png_fixed_point int_blue_Y, png_fixed_point int_blue_Z);
png_uint_32 png_get_eXIf) (png_const_structrp png_ptr, png_inforp info_ptr, png_bytep *exif)
                                          ;
void png_set_eXIf) (png_const_structrp png_ptr, png_inforp info_ptr, png_bytep exif)
                                         ;

png_uint_32 png_get_eXIf_1) (png_const_structrp png_ptr, png_const_inforp info_ptr, png_uint_32 *num_exif, png_bytep *exif)
                                                                       ;
void png_set_eXIf_1) (png_const_structrp png_ptr, png_inforp info_ptr, png_uint_32 num_exif, png_bytep exif)
                                                               ;



png_uint_32 png_get_gAMA) (png_const_structrp png_ptr, png_const_inforp info_ptr, double *file_gamma);

png_uint_32 png_get_gAMA_fixed) (png_const_structrp png_ptr, png_const_inforp info_ptr, png_fixed_point *int_file_gamma);





void png_set_gAMA) (png_const_structrp png_ptr, png_inforp info_ptr, double file_gamma);

void png_set_gAMA_fixed) (png_const_structrp png_ptr, png_inforp info_ptr, png_fixed_point int_file_gamma);




png_uint_32 png_get_hIST) (png_const_structrp png_ptr, png_inforp info_ptr, png_uint_16p *hist)
                                             ;
void png_set_hIST) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_uint_16p hist)
                                                  ;


png_uint_32 png_get_IHDR) (png_const_structrp png_ptr, png_const_inforp info_ptr, png_uint_32 *width, png_uint_32 *height, int *bit_depth, int *color_type, int *interlace_method, int *compression_method, int *filter_method)


                                                 ;

void png_set_IHDR) (png_const_structrp png_ptr, png_inforp info_ptr, png_uint_32 width, png_uint_32 height, int bit_depth, int color_type, int interlace_method, int compression_method, int filter_method)


                       ;


png_uint_32 png_get_oFFs) (png_const_structrp png_ptr, png_const_inforp info_ptr, png_int_32 *offset_x, png_int_32 *offset_y, int *unit_type)

                   ;



void png_set_oFFs) (png_const_structrp png_ptr, png_inforp info_ptr, png_int_32 offset_x, png_int_32 offset_y, int unit_type)

                   ;



png_uint_32 png_get_pCAL) (png_const_structrp png_ptr, png_inforp info_ptr, png_charp *purpose, png_int_32 *X0, png_int_32 *X1, int *type, int *nparams, png_charp *units, png_charpp *params)


                        ;



void png_set_pCAL) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_charp purpose, png_int_32 X0, png_int_32 X1, int type, int nparams, png_const_charp units, png_charpp params)

                                                                     ;



png_uint_32 png_get_pHYs) (png_const_structrp png_ptr, png_const_inforp info_ptr, png_uint_32 *res_x, png_uint_32 *res_y, int *unit_type)

                    ;



void png_set_pHYs) (png_const_structrp png_ptr, png_inforp info_ptr, png_uint_32 res_x, png_uint_32 res_y, int unit_type)
                                                                              ;


png_uint_32 png_get_PLTE) (png_const_structrp png_ptr, png_inforp info_ptr, png_colorp *palette, int *num_palette)
                                                               ;

void png_set_PLTE) (png_structrp png_ptr, png_inforp info_ptr, png_const_colorp palette, int num_palette)
                                                                    ;


png_uint_32 png_get_sBIT) (png_const_structrp png_ptr, png_inforp info_ptr, png_color_8p *sig_bit)
                                                ;



void png_set_sBIT) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_color_8p sig_bit)
                                                     ;



png_uint_32 png_get_sRGB) (png_const_structrp png_ptr, png_const_inforp info_ptr, int *file_srgb_intent)
                                                      ;



void png_set_sRGB) (png_const_structrp png_ptr, png_inforp info_ptr, int srgb_intent)
                                          ;
void png_set_sRGB_gAMA_and_cHRM) (png_const_structrp png_ptr, png_inforp info_ptr, int srgb_intent)
                                          ;



png_uint_32 png_get_iCCP) (png_const_structrp png_ptr, png_inforp info_ptr, png_charpp name, int *compression_type, png_bytepp profile, png_uint_32 *proflen)

                                              ;



void png_set_iCCP) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_charp name, int compression_type, png_const_bytep profile, png_uint_32 proflen)

                                                  ;



int png_get_sPLT) (png_const_structrp png_ptr, png_inforp info_ptr, png_sPLT_tpp entries)
                                               ;



void png_set_sPLT) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_sPLT_tp entries, int nentries)
                                                                  ;




int png_get_text) (png_const_structrp png_ptr, png_inforp info_ptr, png_textp *text_ptr, int *num_text)
                                                             ;
void png_set_text) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_textp text_ptr, int num_text)
                                                                 ;



png_uint_32 png_get_tIME) (png_const_structrp png_ptr, png_inforp info_ptr, png_timep *mod_time)
                                              ;



void png_set_tIME) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_timep mod_time)
                                                   ;



png_uint_32 png_get_tRNS) (png_const_structrp png_ptr, png_inforp info_ptr, png_bytep *trans_alpha, int *num_trans, png_color_16p *trans_color)

                                ;



void png_set_tRNS) (png_structrp png_ptr, png_inforp info_ptr, png_const_bytep trans_alpha, int num_trans, png_const_color_16p trans_color)

                                     ;



png_uint_32 png_get_sCAL) (png_const_structrp png_ptr, png_const_inforp info_ptr, int *unit, double *width, double *height);
png_uint_32 png_get_sCAL_fixed) (png_const_structrp png_ptr, png_const_inforp info_ptr, int *unit, png_fixed_point *width, png_fixed_point *height);



png_uint_32 png_get_sCAL_s) (png_const_structrp png_ptr, png_const_inforp info_ptr, int *unit, png_charpp swidth, png_charpp sheight)

                                           ;

void png_set_sCAL) (png_const_structrp png_ptr, png_inforp info_ptr, int unit, double width, double height);

void png_set_sCAL_fixed) (png_const_structrp png_ptr, png_inforp info_ptr, int unit, png_fixed_point width, png_fixed_point height);


void png_set_sCAL_s) (png_const_structrp png_ptr, png_inforp info_ptr, int unit, png_const_charp swidth, png_const_charp sheight)

                                                     ;
void png_set_keep_unknown_chunks) (png_structrp png_ptr, int keep, png_const_bytep chunk_list, int num_chunks)
                                                          ;






int png_handle_as_unknown) (png_const_structrp png_ptr, png_const_bytep chunk_name)
                                ;



void png_set_unknown_chunks) (png_const_structrp png_ptr, png_inforp info_ptr, png_const_unknown_chunkp unknowns, int num_unknowns)

                      ;
void png_set_unknown_chunk_location) (png_const_structrp png_ptr, png_inforp info_ptr, int chunk, int location)
                                                                               ;

int png_get_unknown_chunks) (png_const_structrp png_ptr, png_inforp info_ptr, png_unknown_chunkpp entries)
                                                      ;






void png_set_invalid) (png_const_structrp png_ptr, png_inforp info_ptr, int mask)
                                   ;




void png_read_png) (png_structrp png_ptr, png_inforp info_ptr, int transforms, png_voidp params)
                                      ;


void png_write_png) (png_structrp png_ptr, png_inforp info_ptr, int transforms, png_voidp params)
                                      ;



png_const_charp png_get_copyright) (png_const_structrp png_ptr)
                                 ;
png_const_charp png_get_header_ver) (png_const_structrp png_ptr)
                                 ;
png_const_charp png_get_header_version) (png_const_structrp png_ptr)
                                 ;
png_const_charp png_get_libpng_ver) (png_const_structrp png_ptr)
                                 ;


png_uint_32 png_permit_mng_features) (png_structrp png_ptr, png_uint_32 mng_features_permitted)
                                        ;



enum {
	PNG_HANDLE_CHUNK_AS_DEFAULT = 0,
	PNG_HANDLE_CHUNK_NEVER = 1,
	PNG_HANDLE_CHUNK_IF_SAFE = 2,
	PNG_HANDLE_CHUNK_ALWAYS = 3,
	PNG_HANDLE_CHUNK_LAST = 4,
};
void png_set_user_limits) (png_structrp png_ptr, png_uint_32 user_width_max, png_uint_32 user_height_max)
                                                             ;
png_uint_32 png_get_user_width_max) (png_const_structrp png_ptr)
                                 ;
png_uint_32 png_get_user_height_max) (png_const_structrp png_ptr)
                                 ;

void png_set_chunk_cache_max) (png_structrp png_ptr, png_uint_32 user_chunk_cache_max)
                                      ;
png_uint_32 png_get_chunk_cache_max) (png_const_structrp png_ptr)
                                 ;

void png_set_chunk_malloc_max) (png_structrp png_ptr, png_alloc_size_t user_chunk_cache_max)
                                           ;
png_alloc_size_t png_get_chunk_malloc_max) (png_const_structrp png_ptr)
                                 ;



png_uint_32 png_get_pixels_per_inch) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;

png_uint_32 png_get_x_pixels_per_inch) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;

png_uint_32 png_get_y_pixels_per_inch) (png_const_structrp png_ptr, png_const_inforp info_ptr)
                                                            ;

float png_get_x_offset_inches) (png_const_structrp png_ptr, png_const_inforp info_ptr);


png_fixed_point png_get_x_offset_inches_fixed) (png_const_structrp png_ptr, png_const_inforp info_ptr);



float png_get_y_offset_inches) (png_const_structrp png_ptr, png_const_inforp info_ptr);


png_fixed_point png_get_y_offset_inches_fixed (png_const_structrp png_ptr, png_const_inforp info_ptr);
png_uint_32 png_get_pHYs_dpi (png_const_structrp png_ptr, png_const_inforp info_ptr, png_uint_32 *res_x, png_uint_32 *res_y, int *unit_type);
png_uint_32 png_get_io_state (png_const_structrp png_ptr);
png_uint_32 png_get_io_chunk_type (png_const_structrp png_ptr);


enum {
	PNG_IO_NONE          = 0x0000,
	PNG_IO_READING       = 0x0001,
	PNG_IO_WRITING       = 0x0002,
	PNG_IO_SIGNATURE     = 0x0010,
	PNG_IO_CHUNK_HDR     = 0x0020,
	PNG_IO_CHUNK_DATA    = 0x0040,
	PNG_IO_CHUNK_CRC     = 0x0080,
	PNG_IO_MASK_OP       = 0x000f,
	PNG_IO_MASK_LOC      = 0x00f0,
};

enum {
	PNG_INTERLACE_ADAM7_PASSES = 7,
};
#define PNG_PASS_START_ROW(pass) (((1&~(pass))<<(3-((pass)>>1)))&7)
#define PNG_PASS_START_COL(pass) (((1& (pass))<<(3-(((pass)+1)>>1)))&7)
#define PNG_PASS_ROW_OFFSET(pass) ((pass)>2?(8>>(((pass)-1)>>1)):8)
#define PNG_PASS_COL_OFFSET(pass) (1<<((7-(pass))>>1))
#define PNG_PASS_ROW_SHIFT(pass) ((pass)>2?(8-(pass))>>1:3)
#define PNG_PASS_COL_SHIFT(pass) ((pass)>1?(7-(pass))>>1:3)
#define PNG_PASS_ROWS(height,pass) (((height)+(((1<<PNG_PASS_ROW_SHIFT(pass)) -1)-PNG_PASS_START_ROW(pass)))>>PNG_PASS_ROW_SHIFT(pass))
#define PNG_PASS_COLS(width,pass) (((width)+(((1<<PNG_PASS_COL_SHIFT(pass)) -1)-PNG_PASS_START_COL(pass)))>>PNG_PASS_COL_SHIFT(pass))
#define PNG_ROW_FROM_PASS_ROW(y_in,pass) (((y_in)<<PNG_PASS_ROW_SHIFT(pass))+PNG_PASS_START_ROW(pass))
#define PNG_COL_FROM_PASS_COL(x_in,pass) (((x_in)<<PNG_PASS_COL_SHIFT(pass))+PNG_PASS_START_COL(pass))
#define PNG_PASS_MASK(pass,off) ( ((0x110145AF>>(((7-(off))-(pass))<<2)) & 0xF) | ((0x01145AF0>>(((7-(off))-(pass))<<2)) & 0xF0))
#define PNG_ROW_IN_INTERLACE_PASS(y,pass) ((PNG_PASS_MASK(pass,0) >> ((y)&7)) & 1)
#define PNG_COL_IN_INTERLACE_PASS(x,pass) ((PNG_PASS_MASK(pass,1) >> ((x)&7)) & 1)
#define png_composite(composite,fg,alpha,bg) { png_uint_16 temp = (png_uint_16)((png_uint_16)(fg) * (png_uint_16)(alpha) + (png_uint_16)(bg)*(png_uint_16)(255 - (png_uint_16)(alpha)) + 128); (composite) = (png_byte)(((temp + (temp >> 8)) >> 8) & 0xff); }
#define png_composite_16(composite,fg,alpha,bg) { png_uint_32 temp = (png_uint_32)((png_uint_32)(fg) * (png_uint_32)(alpha) + (png_uint_32)(bg)*(65535 - (png_uint_32)(alpha)) + 32768); (composite) = (png_uint_16)(0xffff & ((temp + (temp >> 16)) >> 16)); }
png_uint_32 png_get_uint_32 (png_const_bytep buf);
png_uint_16 png_get_uint_16 (png_const_bytep buf);
png_int_32 png_get_int_32 (png_const_bytep buf);
png_uint_32 png_get_uint_31 (png_const_structrp png_ptr, png_const_bytep buf);
void png_save_uint_32 (png_bytep buf, png_uint_32 i);
void png_save_int_32 (png_bytep buf, png_int_32 i);
void png_save_uint_16 (png_bytep buf, unsigned int i);
#define PNG_get_uint_32(buf) (((png_uint_32)(*(buf)) << 24) + ((png_uint_32)(*((buf) + 1)) << 16) + ((png_uint_32)(*((buf) + 2)) << 8) + ((png_uint_32)(*((buf) + 3))))
#define PNG_get_uint_16(buf) ((png_uint_16) (((unsigned int)(*(buf)) << 8) + ((unsigned int)(*((buf) + 1)))))
#define PNG_get_int_32(buf) ((png_int_32)((*(buf) & 0x80) ? -((png_int_32)(((png_get_uint_32(buf)^0xffffffffU)+1U)&0x7fffffffU)) : (png_int_32)png_get_uint_32(buf)))
#define png_get_uint_32(buf) PNG_get_uint_32(buf)
#define png_get_uint_16(buf) PNG_get_uint_16(buf)
#define png_get_int_32(buf) PNG_get_int_32(buf)
void png_set_check_for_invalid_index (png_structrp png_ptr, int allowed);
int png_get_palette_max (png_const_structp png_ptr, png_const_infop info_ptr);

]]
