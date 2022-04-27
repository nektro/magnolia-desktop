//! Constants imported from https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/include/GL/gl.h

pub const Bool = enum(c_uint) {
    FALSE = 0,
    TRUE = 1,
};

pub const Type = enum(c_uint) {
    GL_BYTE = 0x1400,
    GL_UNSIGNED_BYTE = 0x1401,
    GL_SHORT = 0x1402,
    GL_UNSIGNED_SHORT = 0x1403,
    GL_INT = 0x1404,
    GL_UNSIGNED_INT = 0x1405,
    GL_FLOAT = 0x1406,
    GL_2_BYTES = 0x1407,
    GL_3_BYTES = 0x1408,
    GL_4_BYTES = 0x1409,
    GL_DOUBLE = 0x140A,
};

pub const Primitive = enum(c_uint) {
    POINTS = 0x0000,
    LINES = 0x0001,
    LINE_LOOP = 0x0002,
    LINE_STRIP = 0x0003,
    TRIANGLES = 0x0004,
    TRIANGLE_STRIP = 0x0005,
    TRIANGLE_FAN = 0x0006,
    QUADS = 0x0007,
    QUAD_STRIP = 0x0008,
    POLYGON = 0x0009,
};

pub const VertexArray = enum(c_uint) {
    VERTEX_ARRAY = 0x8074,
    NORMAL_ARRAY = 0x8075,
    COLOR_ARRAY = 0x8076,
    INDEX_ARRAY = 0x8077,
    TEXTURE_COORD_ARRAY = 0x8078,
    EDGE_FLAG_ARRAY = 0x8079,
    VERTEX_ARRAY_SIZE = 0x807A,
    VERTEX_ARRAY_TYPE = 0x807B,
    VERTEX_ARRAY_STRIDE = 0x807C,
    NORMAL_ARRAY_TYPE = 0x807E,
    NORMAL_ARRAY_STRIDE = 0x807F,
    COLOR_ARRAY_SIZE = 0x8081,
    COLOR_ARRAY_TYPE = 0x8082,
    COLOR_ARRAY_STRIDE = 0x8083,
    INDEX_ARRAY_TYPE = 0x8085,
    INDEX_ARRAY_STRIDE = 0x8086,
    TEXTURE_COORD_ARRAY_SIZE = 0x8088,
    TEXTURE_COORD_ARRAY_TYPE = 0x8089,
    TEXTURE_COORD_ARRAY_STRIDE = 0x808A,
    EDGE_FLAG_ARRAY_STRIDE = 0x808C,
    VERTEX_ARRAY_POINTER = 0x808E,
    NORMAL_ARRAY_POINTER = 0x808F,
    COLOR_ARRAY_POINTER = 0x8090,
    INDEX_ARRAY_POINTER = 0x8091,
    TEXTURE_COORD_ARRAY_POINTER = 0x8092,
    EDGE_FLAG_ARRAY_POINTER = 0x8093,
    V2F = 0x2A20,
    V3F = 0x2A21,
    C4UB_V2F = 0x2A22,
    C4UB_V3F = 0x2A23,
    C3F_V3F = 0x2A24,
    N3F_V3F = 0x2A25,
    C4F_N3F_V3F = 0x2A26,
    T2F_V3F = 0x2A27,
    T4F_V4F = 0x2A28,
    T2F_C4UB_V3F = 0x2A29,
    T2F_C3F_V3F = 0x2A2A,
    T2F_N3F_V3F = 0x2A2B,
    T2F_C4F_N3F_V3F = 0x2A2C,
    T4F_C4F_N3F_V4F = 0x2A2D,
};

pub const MatrixMode = enum(c_uint) {
    MATRIX_MODE = 0x0BA0,
    MODELVIEW = 0x1700,
    PROJECTION = 0x1701,
    TEXTURE = 0x1702,
};

pub const Point = enum(c_uint) {
    SMOOTH = 0x0B10,
    SIZE = 0x0B11,
    SIZE_GRANULARITY = 0x0B13,
    SIZE_RANGE = 0x0B12,
};

pub const Line = enum(c_uint) {
    SMOOTH = 0x0B20,
    STIPPLE = 0x0B24,
    STIPPLE_PATTERN = 0x0B25,
    STIPPLE_REPEAT = 0x0B26,
    WIDTH = 0x0B21,
    WIDTH_GRANULARITY = 0x0B23,
    WIDTH_RANGE = 0x0B22,
};

pub const Polygon = enum(c_uint) {
    POINT = 0x1B00,
    LINE = 0x1B01,
    FILL = 0x1B02,
    CW = 0x0900,
    CCW = 0x0901,
    FRONT = 0x0404,
    BACK = 0x0405,
    POLYGON_MODE = 0x0B40,
    POLYGON_SMOOTH = 0x0B41,
    POLYGON_STIPPLE = 0x0B42,
    EDGE_FLAG = 0x0B43,
    CULL_FACE = 0x0B44,
    CULL_FACE_MODE = 0x0B45,
    FRONT_FACE = 0x0B46,
    POLYGON_OFFSET_FACTOR = 0x8038,
    POLYGON_OFFSET_UNITS = 0x2A00,
    POLYGON_OFFSET_POINT = 0x2A01,
    POLYGON_OFFSET_LINE = 0x2A02,
    POLYGON_OFFSET_FILL = 0x8037,
};

pub const DisplayList = enum(c_uint) {
    COMPILE = 0x1300,
    COMPILE_AND_EXECUTE = 0x1301,
    LIST_BASE = 0x0B32,
    LIST_INDEX = 0x0B33,
    LIST_MODE = 0x0B30,
};

pub const DepthBuffer = enum(c_uint) {
    NEVER = 0x0200,
    LESS = 0x0201,
    EQUAL = 0x0202,
    LEQUAL = 0x0203,
    GREATER = 0x0204,
    NOTEQUAL = 0x0205,
    GEQUAL = 0x0206,
    ALWAYS = 0x0207,
    DEPTH_TEST = 0x0B71,
    DEPTH_BITS = 0x0D56,
    DEPTH_CLEAR_VALUE = 0x0B73,
    DEPTH_FUNC = 0x0B74,
    DEPTH_RANGE = 0x0B70,
    DEPTH_WRITEMASK = 0x0B72,
    DEPTH_COMPONENT = 0x1902,
};

pub const Lighting = enum(c_uint) {
    // /* Lighting */
    LIGHTING = 0x0B50,
    LIGHT0 = 0x4000,
    LIGHT1 = 0x4001,
    LIGHT2 = 0x4002,
    LIGHT3 = 0x4003,
    LIGHT4 = 0x4004,
    LIGHT5 = 0x4005,
    LIGHT6 = 0x4006,
    LIGHT7 = 0x4007,
    SPOT_EXPONENT = 0x1205,
    SPOT_CUTOFF = 0x1206,
    CONSTANT_ATTENUATION = 0x1207,
    LINEAR_ATTENUATION = 0x1208,
    QUADRATIC_ATTENUATION = 0x1209,
    AMBIENT = 0x1200,
    DIFFUSE = 0x1201,
    SPECULAR = 0x1202,
    SHININESS = 0x1601,
    EMISSION = 0x1600,
    POSITION = 0x1203,
    SPOT_DIRECTION = 0x1204,
    AMBIENT_AND_DIFFUSE = 0x1602,
    COLOR_INDEXES = 0x1603,
    LIGHT_MODEL_TWO_SIDE = 0x0B52,
    LIGHT_MODEL_LOCAL_VIEWER = 0x0B51,
    LIGHT_MODEL_AMBIENT = 0x0B53,
    FRONT_AND_BACK = 0x0408,
    SHADE_MODEL = 0x0B54,
    FLAT = 0x1D00,
    SMOOTH = 0x1D01,
    COLOR_MATERIAL = 0x0B57,
    COLOR_MATERIAL_FACE = 0x0B55,
    COLOR_MATERIAL_PARAMETER = 0x0B56,
    NORMALIZE = 0x0BA1,
};

pub const ClippingPlane = enum(c_uint) {
    // /* User clipping planes */
    PLANE0 = 0x3000,
    PLANE1 = 0x3001,
    PLANE2 = 0x3002,
    PLANE3 = 0x3003,
    PLANE4 = 0x3004,
    PLANE5 = 0x3005,
};

pub const AccumulationBuffer = enum(c_uint) {
    // /* Accumulation buffer */
    ACCUM_RED_BITS = 0x0D58,
    ACCUM_GREEN_BITS = 0x0D59,
    ACCUM_BLUE_BITS = 0x0D5A,
    ACCUM_ALPHA_BITS = 0x0D5B,
    ACCUM_CLEAR_VALUE = 0x0B80,
    ACCUM = 0x0100,
    ADD = 0x0104,
    LOAD = 0x0101,
    MULT = 0x0103,
    RETURN = 0x0102,
};

pub const AlphaTest = enum(c_uint) {
    // /* Alpha testing */
    TEST = 0x0BC0,
    TEST_REF = 0x0BC2,
    TEST_FUNC = 0x0BC1,
};

pub const Blending = enum(c_uint) {
    // /* Blending */
    BLEND = 0x0BE2,
    BLEND_SRC = 0x0BE1,
    BLEND_DST = 0x0BE0,
    ZERO = 0,
    ONE = 1,
    SRC_COLOR = 0x0300,
    ONE_MINUS_SRC_COLOR = 0x0301,
    SRC_ALPHA = 0x0302,
    ONE_MINUS_SRC_ALPHA = 0x0303,
    DST_ALPHA = 0x0304,
    ONE_MINUS_DST_ALPHA = 0x0305,
    DST_COLOR = 0x0306,
    ONE_MINUS_DST_COLOR = 0x0307,
    SRC_ALPHA_SATURATE = 0x0308,
};

pub const RenderMode = enum(c_uint) {
    // /* Render Mode */
    FEEDBACK = 0x1C01,
    RENDER = 0x1C00,
    SELECT = 0x1C02,
};

pub const Feedback = enum(c_uint) {
    // /* Feedback */
    _2D = 0x0600,
    _3D = 0x0601,
    _3D_COLOR = 0x0602,
    _3D_COLOR_TEXTURE = 0x0603,
    _4D_COLOR_TEXTURE = 0x0604,
    POINT_TOKEN = 0x0701,
    LINE_TOKEN = 0x0702,
    LINE_RESET_TOKEN = 0x0707,
    POLYGON_TOKEN = 0x0703,
    BITMAP_TOKEN = 0x0704,
    DRAW_PIXEL_TOKEN = 0x0705,
    COPY_PIXEL_TOKEN = 0x0706,
    PASS_THROUGH_TOKEN = 0x0700,
    FEEDBACK_BUFFER_POINTER = 0x0DF0,
    FEEDBACK_BUFFER_SIZE = 0x0DF1,
    FEEDBACK_BUFFER_TYPE = 0x0DF2,
};

pub const SelectionBuffer = enum(c_uint) {
    // /* Selection */
    POINTER = 0x0DF3,
    SIZE = 0x0DF4,
};

pub const Fog = enum(c_uint) {
    // /* Fog */
    FOG = 0x0B60,
    FOG_MODE = 0x0B65,
    FOG_DENSITY = 0x0B62,
    FOG_COLOR = 0x0B66,
    FOG_INDEX = 0x0B61,
    FOG_START = 0x0B63,
    FOG_END = 0x0B64,
    LINEAR = 0x2601,
    EXP = 0x0800,
    EXP2 = 0x0801,
};

pub const LogicOp = enum(c_uint) {
    // /* Logic Ops */
    LOGIC_OP = 0x0BF1,
    INDEX_LOGIC_OP = 0x0BF1,
    COLOR_LOGIC_OP = 0x0BF2,
    LOGIC_OP_MODE = 0x0BF0,
    CLEAR = 0x1500,
    SET = 0x150F,
    COPY = 0x1503,
    COPY_INVERTED = 0x150C,
    NOOP = 0x1505,
    INVERT = 0x150A,
    AND = 0x1501,
    NAND = 0x150E,
    OR = 0x1507,
    NOR = 0x1508,
    XOR = 0x1506,
    EQUIV = 0x1509,
    AND_REVERSE = 0x1502,
    AND_INVERTED = 0x1504,
    OR_REVERSE = 0x150B,
    OR_INVERTED = 0x150D,
};

pub const Stencil = enum(c_uint) {
    // /* Stencil */
    STENCIL_BITS = 0x0D57,
    STENCIL_TEST = 0x0B90,
    STENCIL_CLEAR_VALUE = 0x0B91,
    STENCIL_FUNC = 0x0B92,
    STENCIL_VALUE_MASK = 0x0B93,
    STENCIL_FAIL = 0x0B94,
    STENCIL_PASS_DEPTH_FAIL = 0x0B95,
    STENCIL_PASS_DEPTH_PASS = 0x0B96,
    STENCIL_REF = 0x0B97,
    STENCIL_WRITEMASK = 0x0B98,
    STENCIL_INDEX = 0x1901,
    KEEP = 0x1E00,
    REPLACE = 0x1E01,
    INCR = 0x1E02,
    DECR = 0x1E03,
};

// /* Buffers, Pixel Drawing/Reading */
// #define GL_NONE              0
// #define GL_LEFT              0x0406
// #define GL_RIGHT              0x0407
// /*GL_FRONT              0x0404 */
// /*GL_BACK              0x0405 */
// /*GL_FRONT_AND_BACK              0x0408 */
// #define GL_FRONT_LEFT              0x0400
// #define GL_FRONT_RIGHT              0x0401
// #define GL_BACK_LEFT              0x0402
// #define GL_BACK_RIGHT              0x0403
// #define GL_AUX0              0x0409
// #define GL_AUX1              0x040A
// #define GL_AUX2              0x040B
// #define GL_AUX3              0x040C
// #define GL_COLOR_INDEX              0x1900
// #define GL_RED              0x1903
// #define GL_GREEN              0x1904
// #define GL_BLUE              0x1905
// #define GL_ALPHA              0x1906
// #define GL_LUMINANCE              0x1909
// #define GL_LUMINANCE_ALPHA              0x190A
// #define GL_ALPHA_BITS              0x0D55
// #define GL_RED_BITS              0x0D52
// #define GL_GREEN_BITS              0x0D53
// #define GL_BLUE_BITS              0x0D54
// #define GL_INDEX_BITS              0x0D51
// #define GL_SUBPIXEL_BITS              0x0D50
// #define GL_AUX_BUFFERS              0x0C00
// #define GL_READ_BUFFER              0x0C02
// #define GL_DRAW_BUFFER              0x0C01
// #define GL_DOUBLEBUFFER              0x0C32
// #define GL_STEREO              0x0C33
// #define GL_BITMAP              0x1A00
// #define GL_COLOR              0x1800
// #define GL_DEPTH              0x1801
// #define GL_STENCIL              0x1802
// #define GL_DITHER              0x0BD0
// #define GL_RGB              0x1907
// #define GL_RGBA              0x1908

pub const ImplementationMax = enum(c_uint) {
    // /* Implementation limits */
    LIST_NESTING = 0x0B31,
    EVAL_ORDER = 0x0D30,
    LIGHTS = 0x0D31,
    CLIP_PLANES = 0x0D32,
    TEXTURE_SIZE = 0x0D33,
    PIXEL_MAP_TABLE = 0x0D34,
    ATTRIB_STACK_DEPTH = 0x0D35,
    MODELVIEW_STACK_DEPTH = 0x0D36,
    NAME_STACK_DEPTH = 0x0D37,
    PROJECTION_STACK_DEPTH = 0x0D38,
    TEXTURE_STACK_DEPTH = 0x0D39,
    VIEWPORT_DIMS = 0x0D3A,
    CLIENT_ATTRIB_STACK_DEPTH = 0x0D3B,
};

pub const Get = enum(c_uint) {
    // /* Gets */
    ATTRIB_STACK_DEPTH = 0x0BB0,
    CLIENT_ATTRIB_STACK_DEPTH = 0x0BB1,
    COLOR_CLEAR_VALUE = 0x0C22,
    COLOR_WRITEMASK = 0x0C23,
    CURRENT_INDEX = 0x0B01,
    CURRENT_COLOR = 0x0B00,
    CURRENT_NORMAL = 0x0B02,
    CURRENT_RASTER_COLOR = 0x0B04,
    CURRENT_RASTER_DISTANCE = 0x0B09,
    CURRENT_RASTER_INDEX = 0x0B05,
    CURRENT_RASTER_POSITION = 0x0B07,
    CURRENT_RASTER_TEXTURE_COORDS = 0x0B06,
    CURRENT_RASTER_POSITION_VALID = 0x0B08,
    CURRENT_TEXTURE_COORDS = 0x0B03,
    INDEX_CLEAR_VALUE = 0x0C20,
    INDEX_MODE = 0x0C30,
    INDEX_WRITEMASK = 0x0C21,
    MODELVIEW_MATRIX = 0x0BA6,
    MODELVIEW_STACK_DEPTH = 0x0BA3,
    NAME_STACK_DEPTH = 0x0D70,
    PROJECTION_MATRIX = 0x0BA7,
    PROJECTION_STACK_DEPTH = 0x0BA4,
    RENDER_MODE = 0x0C40,
    RGBA_MODE = 0x0C31,
    TEXTURE_MATRIX = 0x0BA8,
    TEXTURE_STACK_DEPTH = 0x0BA5,
    VIEWPORT = 0x0BA2,
};

pub const Evaluator = enum(c_uint) {
    // /* Evaluators */
    AUTO_NORMAL = 0x0D80,
    MAP1_COLOR_4 = 0x0D90,
    MAP1_INDEX = 0x0D91,
    MAP1_NORMAL = 0x0D92,
    MAP1_TEXTURE_COORD_1 = 0x0D93,
    MAP1_TEXTURE_COORD_2 = 0x0D94,
    MAP1_TEXTURE_COORD_3 = 0x0D95,
    MAP1_TEXTURE_COORD_4 = 0x0D96,
    MAP1_VERTEX_3 = 0x0D97,
    MAP1_VERTEX_4 = 0x0D98,
    MAP2_COLOR_4 = 0x0DB0,
    MAP2_INDEX = 0x0DB1,
    MAP2_NORMAL = 0x0DB2,
    MAP2_TEXTURE_COORD_1 = 0x0DB3,
    MAP2_TEXTURE_COORD_2 = 0x0DB4,
    MAP2_TEXTURE_COORD_3 = 0x0DB5,
    MAP2_TEXTURE_COORD_4 = 0x0DB6,
    MAP2_VERTEX_3 = 0x0DB7,
    MAP2_VERTEX_4 = 0x0DB8,
    MAP1_GRID_DOMAIN = 0x0DD0,
    MAP1_GRID_SEGMENTS = 0x0DD1,
    MAP2_GRID_DOMAIN = 0x0DD2,
    MAP2_GRID_SEGMENTS = 0x0DD3,
    COEFF = 0x0A00,
    ORDER = 0x0A01,
    DOMAIN = 0x0A02,
};

pub const Hint = enum(c_uint) {
    // /* Hints */
    PERSPECTIVE_CORRECTION_HINT = 0x0C50,
    POINT_SMOOTH_HINT = 0x0C51,
    LINE_SMOOTH_HINT = 0x0C52,
    POLYGON_SMOOTH_HINT = 0x0C53,
    FOG_HINT = 0x0C54,
    DONT_CARE = 0x1100,
    FASTEST = 0x1101,
    NICEST = 0x1102,
};

pub const Scissor = enum(c_uint) {
    // /* Scissor box */
    BOX = 0x0C10,
    TEST = 0x0C11,
};

pub const PixelMode = enum(c_uint) {
    // /* Pixel Mode / Transfer */
    MAP_COLOR = 0x0D10,
    MAP_STENCIL = 0x0D11,
    INDEX_SHIFT = 0x0D12,
    INDEX_OFFSET = 0x0D13,
    RED_SCALE = 0x0D14,
    RED_BIAS = 0x0D15,
    GREEN_SCALE = 0x0D18,
    GREEN_BIAS = 0x0D19,
    BLUE_SCALE = 0x0D1A,
    BLUE_BIAS = 0x0D1B,
    ALPHA_SCALE = 0x0D1C,
    ALPHA_BIAS = 0x0D1D,
    DEPTH_SCALE = 0x0D1E,
    DEPTH_BIAS = 0x0D1F,
    PIXEL_MAP_S_TO_S_SIZE = 0x0CB1,
    PIXEL_MAP_I_TO_I_SIZE = 0x0CB0,
    PIXEL_MAP_I_TO_R_SIZE = 0x0CB2,
    PIXEL_MAP_I_TO_G_SIZE = 0x0CB3,
    PIXEL_MAP_I_TO_B_SIZE = 0x0CB4,
    PIXEL_MAP_I_TO_A_SIZE = 0x0CB5,
    PIXEL_MAP_R_TO_R_SIZE = 0x0CB6,
    PIXEL_MAP_G_TO_G_SIZE = 0x0CB7,
    PIXEL_MAP_B_TO_B_SIZE = 0x0CB8,
    PIXEL_MAP_A_TO_A_SIZE = 0x0CB9,
    PIXEL_MAP_S_TO_S = 0x0C71,
    PIXEL_MAP_I_TO_I = 0x0C70,
    PIXEL_MAP_I_TO_R = 0x0C72,
    PIXEL_MAP_I_TO_G = 0x0C73,
    PIXEL_MAP_I_TO_B = 0x0C74,
    PIXEL_MAP_I_TO_A = 0x0C75,
    PIXEL_MAP_R_TO_R = 0x0C76,
    PIXEL_MAP_G_TO_G = 0x0C77,
    PIXEL_MAP_B_TO_B = 0x0C78,
    PIXEL_MAP_A_TO_A = 0x0C79,
    PACK_ALIGNMENT = 0x0D05,
    PACK_LSB_FIRST = 0x0D01,
    PACK_ROW_LENGTH = 0x0D02,
    PACK_SKIP_PIXELS = 0x0D04,
    PACK_SKIP_ROWS = 0x0D03,
    PACK_SWAP_BYTES = 0x0D00,
    UNPACK_ALIGNMENT = 0x0CF5,
    UNPACK_LSB_FIRST = 0x0CF1,
    UNPACK_ROW_LENGTH = 0x0CF2,
    UNPACK_SKIP_PIXELS = 0x0CF4,
    UNPACK_SKIP_ROWS = 0x0CF3,
    UNPACK_SWAP_BYTES = 0x0CF0,
    ZOOM_X = 0x0D16,
    ZOOM_Y = 0x0D17,
};

pub const TextureMapping = enum(c_uint) {
    // /* Texture mapping */
    TEXTURE_ENV = 0x2300,
    TEXTURE_ENV_MODE = 0x2200,
    TEXTURE_1D = 0x0DE0,
    TEXTURE_2D = 0x0DE1,
    TEXTURE_WRAP_S = 0x2802,
    TEXTURE_WRAP_T = 0x2803,
    TEXTURE_MAG_FILTER = 0x2800,
    TEXTURE_MIN_FILTER = 0x2801,
    TEXTURE_ENV_COLOR = 0x2201,
    TEXTURE_GEN_S = 0x0C60,
    TEXTURE_GEN_T = 0x0C61,
    TEXTURE_GEN_R = 0x0C62,
    TEXTURE_GEN_Q = 0x0C63,
    TEXTURE_GEN_MODE = 0x2500,
    TEXTURE_BORDER_COLOR = 0x1004,
    TEXTURE_WIDTH = 0x1000,
    TEXTURE_HEIGHT = 0x1001,
    TEXTURE_BORDER = 0x1005,
    TEXTURE_COMPONENTS = 0x1003,
    TEXTURE_RED_SIZE = 0x805C,
    TEXTURE_GREEN_SIZE = 0x805D,
    TEXTURE_BLUE_SIZE = 0x805E,
    TEXTURE_ALPHA_SIZE = 0x805F,
    TEXTURE_LUMINANCE_SIZE = 0x8060,
    TEXTURE_INTENSITY_SIZE = 0x8061,
    NEAREST_MIPMAP_NEAREST = 0x2700,
    NEAREST_MIPMAP_LINEAR = 0x2702,
    LINEAR_MIPMAP_NEAREST = 0x2701,
    LINEAR_MIPMAP_LINEAR = 0x2703,
    OBJECT_LINEAR = 0x2401,
    OBJECT_PLANE = 0x2501,
    EYE_LINEAR = 0x2400,
    EYE_PLANE = 0x2502,
    SPHERE_MAP = 0x2402,
    DECAL = 0x2101,
    MODULATE = 0x2100,
    NEAREST = 0x2600,
    REPEAT = 0x2901,
    CLAMP = 0x2900,
    S = 0x2000,
    T = 0x2001,
    R = 0x2002,
    Q = 0x2003,
};

pub const Utility = enum(c_uint) {
    VENDOR = 0x1F00,
    RENDERER = 0x1F01,
    VERSION = 0x1F02,
    EXTENSIONS = 0x1F03,
};

pub const Error = enum(c_uint) {
    NO_ERROR = 0,
    INVALID_ENUM = 0x0500,
    INVALID_VALUE = 0x0501,
    INVALID_OPERATION = 0x0502,
    STACK_OVERFLOW = 0x0503,
    STACK_UNDERFLOW = 0x0504,
    OUT_OF_MEMORY = 0x0505,
};

pub const PushPopAttribBit = enum(c_uint) {
    // /* glPush/PopAttrib bits */
    CURRENT_BIT = 0x00000001,
    POINT_BIT = 0x00000002,
    LINE_BIT = 0x00000004,
    POLYGON_BIT = 0x00000008,
    POLYGON_STIPPLE_BIT = 0x00000010,
    PIXEL_MODE_BIT = 0x00000020,
    LIGHTING_BIT = 0x00000040,
    FOG_BIT = 0x00000080,
    DEPTH_BUFFER_BIT = 0x00000100,
    ACCUM_BUFFER_BIT = 0x00000200,
    STENCIL_BUFFER_BIT = 0x00000400,
    VIEWPORT_BIT = 0x00000800,
    TRANSFORM_BIT = 0x00001000,
    ENABLE_BIT = 0x00002000,
    COLOR_BUFFER_BIT = 0x00004000,
    HINT_BIT = 0x00008000,
    EVAL_BIT = 0x00010000,
    LIST_BIT = 0x00020000,
    TEXTURE_BIT = 0x00040000,
    SCISSOR_BIT = 0x00080000,
    ALL_ATTRIB_BITS = 0xFFFFFFFF,
};

// /* OpenGL 1.1 */
// #define GL_PROXY_TEXTURE_1D              0x8063
// #define GL_PROXY_TEXTURE_2D              0x8064
// #define GL_TEXTURE_PRIORITY              0x8066
// #define GL_TEXTURE_RESIDENT              0x8067
// #define GL_TEXTURE_BINDING_1D              0x8068
// #define GL_TEXTURE_BINDING_2D              0x8069
// #define GL_TEXTURE_INTERNAL_FORMAT              0x1003
// #define GL_ALPHA4              0x803B
// #define GL_ALPHA8              0x803C
// #define GL_ALPHA12              0x803D
// #define GL_ALPHA16              0x803E
// #define GL_LUMINANCE4              0x803F
// #define GL_LUMINANCE8              0x8040
// #define GL_LUMINANCE12              0x8041
// #define GL_LUMINANCE16              0x8042
// #define GL_LUMINANCE4_ALPHA4              0x8043
// #define GL_LUMINANCE6_ALPHA2              0x8044
// #define GL_LUMINANCE8_ALPHA8              0x8045
// #define GL_LUMINANCE12_ALPHA4              0x8046
// #define GL_LUMINANCE12_ALPHA12              0x8047
// #define GL_LUMINANCE16_ALPHA16              0x8048
// #define GL_INTENSITY              0x8049
// #define GL_INTENSITY4              0x804A
// #define GL_INTENSITY8              0x804B
// #define GL_INTENSITY12              0x804C
// #define GL_INTENSITY16              0x804D
// #define GL_R3_G3_B2              0x2A10
// #define GL_RGB4              0x804F
// #define GL_RGB5              0x8050
// #define GL_RGB8              0x8051
// #define GL_RGB10              0x8052
// #define GL_RGB12              0x8053
// #define GL_RGB16              0x8054
// #define GL_RGBA2              0x8055
// #define GL_RGBA4              0x8056
// #define GL_RGB5_A1              0x8057
// #define GL_RGBA8              0x8058
// #define GL_RGB10_A2              0x8059
// #define GL_RGBA12              0x805A
// #define GL_RGBA16              0x805B
// #define GL_CLIENT_PIXEL_STORE_BIT              0x00000001
// #define GL_CLIENT_VERTEX_ARRAY_BIT              0x00000002
// #define GL_ALL_CLIENT_ATTRIB_BITS               0xFFFFFFFF
// #define GL_CLIENT_ALL_ATTRIB_BITS               0xFFFFFFFF
