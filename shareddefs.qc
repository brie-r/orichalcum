void() main;
void() StartFrame;
void() PlayerPreThink;
void() PlayerPostThink;
void() ClientKill;
void() ClientConnect;
void() PutClientInServer;
void() ClientDisconnect;
void() SetNewParms;
void() SetChangeParms;
//Some custom types (that might be redefined as accessors by fteextensions.qc, although we don't define any methods here)
#ifdef _ACCESSORS
accessor strbuf:float;
accessor searchhandle:float;
accessor hashtable:float;
accessor infostring:string;
accessor filestream:float;
#else
#define strbuf float
#define searchhandle float
#define hashtable float
#define infostring string
#define filestream float
#endif
vector(vector fwd, optional vector up) vectoangles2 = #51; // Returns the angles (+x=UP) required to orient an entity to look in the given direction. The 'up' argument is required if you wish to set a roll angle, otherwise it will be limited to just monster-style turning.
float(float angle) sin = #60; 
float(float angle) cos = #61; 
float(float value) sqrt = #62; 
void(entity ent, entity ignore) tracetoss = #64; 
string(entity ent) etos = #65; 
float(entity ent) etof = #0; 
entity(float ent) ftoe = #0; 
float(string) stof = #81; 
void(vector start, vector mins, vector maxs, vector end, float nomonsters, entity ent) tracebox = #90; // Exactly like traceline, but a box instead of a uselessly thin point. Acceptable sizes are limited by bsp format, q1bsp has strict acceptable size values.
vector() randomvec = #91; // Returns a vector with random values. Each axis is independantly a value between -1 and 1 inclusive.
vector(vector org) getlight = #92; 
float(string cvarname, string defaultvalue) registercvar = #93; // Creates a new cvar on the fly. If it does not already exist, it will be given the specified value. If it does exist, this is a no-op.
// This builtin has the limitation that it does not apply to configs or commandlines. Such configs will need to use the set or seta command causing this builtin to be a noop.
// In engines that support it, you will generally find the autocvar feature easier and more efficient to use.
float(float a, float b, ...) min = #94; // Returns the lowest value of its arguments.
float(float a, float b, ...) max = #95; // Returns the highest value of its arguments.
float(float minimum, float val, float maximum) bound = #96; // Returns val, unless minimum is higher, or maximum is less.
float(float value, float exp) pow = #97; 
#define findentity findfloat
entity(entity start, .__variant fld, __variant match) findfloat = #98; // Equivelent to the find builtin, but instead of comparing strings contents, this builtin compares the raw values. This builtin requires multiple calls in order to scan all entities - set start to the previous call's return value.
// world is returned when there are no more entities.
float(string extname) checkextension = #99; // Checks for an extension by its name (eg: checkextension(\,FRIK_FILE\ says that its okay to go ahead and use strcat).
// Use cvar(\,pr_checkextension\ to see if this builtin exists.
float(__variant funcref) checkbuiltin = #0; // Checks to see if the specified builtin is supported/mapped. This is intended as a way to check for #0 functions, allowing for simple single-builtin functions.
float(string builtinname) builtin_find = #100; // Looks to see if the named builtin is valid, and returns the builtin number it exists at.
float(float value) anglemod = #102; 
float(string s) strlen = #114; 
string(string s1, optional string s2, optional string s3, optional string s4, optional string s5, optional string s6, optional string s7, optional string s8) strcat = #115; 
string(string s, float start, float length) substring = #116; 
vector(string s) stov = #117; 
string(string s, ...) strzone = #118; // Create a semi-permanent copy of a string that only becomes invalid once strunzone is called on the string (instead of when the engine assumes your string has left scope).
void(string s) strunzone = #119; // Destroys a string that was allocated by strunzone. Further references to the string MAY crash the game.
float(string s) tokenize_menuqc = #0; 
float(float number, float quantity) bitshift = #218; 
float(string s1, string sub, optional float startidx) strstrofs = #221; // Returns the 0-based offset of sub within the s1 string, or -1 if sub is not in s1.
// If startidx is set, this builtin will ignore matches before that 0-based offset.
float(string str, float index) str2chr = #222; // Retrieves the character value at offset 'index'.
string(float chr, ...) chr2str = #223; // The input floats are considered character values, and are concatenated.
string(float ccase, float redalpha, float redchars, string str, ...) strconv = #224; // Converts quake chars in the input string amongst different representations.
// ccase specifies the new case for letters.
//  0: not changed.
//  1: forced to lower case.
//  2: forced to upper case.
// redalpha and redchars switch between colour ranges.
//  0: no change.
//  1: Forced white.
//  2: Forced red.
//  3: Forced gold(low) (numbers only).
//  4: Forced gold (high) (numbers only).
//  5+6: Forced to white and red alternately.
// You should not use this builtin in combination with UTF-8.
string(float pad, string str1, ...) strpad = #5; // Pads the string with spaces, to ensure its a specific length (so long as a fixed-width font is used, anyway). If pad is negative, the spaces are added on the left. If positive the padding is on the right.
string(infostring old, string key, string value) infoadd = #226; // Returns a new tempstring infostring with the named value changed (or added if it was previously unspecified). Key and value may not contain the \\ character.
string(infostring info, string key) infoget = #227; // Reads a named value from an infostring. The returned value is a tempstring
#define strcmp strncmp
float(string s1, string s2, optional float len, optional float s1ofs, optional float s2ofs) strncmp = #228; // Compares up to 'len' chars in the two strings. s1ofs allows you to treat s2 as a substring to compare against, or should be 0.
// Returns 0 if the two strings are equal, a negative value if s1 appears numerically lower, and positive if s1 appears numerically higher.
float(string s1, string s2) strcasecmp = #229; // Compares the two strings without case sensitivity.
// Returns 0 if they are equal. The sign of the return value may be significant, but should not be depended upon.
float(string s1, string s2, float len, optional float s1ofs, optional float s2ofs) strncasecmp = #230; // Compares up to 'len' chars in the two strings without case sensitivity. s1ofs allows you to treat s2 as a substring to compare against, or should be 0.
// Returns 0 if they are equal. The sign of the return value may be significant, but should not be depended upon.
string(string s) strtrim = #0; // Trims the whitespace from the start+end of the string.
float(vector viewpos, entity entity) checkpvs = #240; 
float(float a, float n) mod = #245; 
int(string) stoi = #259; // Converts the given string into a true integer. Base 8, 10, or 16 is determined based upon the format of the string.
string(int) itos = #260; // Converts the passed true integer into a base10 string.
int(string) stoh = #261; // Reads a base-16 string (with or without 0x prefix) as an integer. Bugs out if given a base 8 or base 10 string. :P
string(int) htos = #262; // Formats an integer as a base16 string, with leading 0s and no prefix. Always returns 8 characters.
int(float) ftoi = #0; // Converts the given float into a true integer without depending on extended qcvm instructions.
float(int) itof = #0; // Converts the given true integer into a float without depending on extended qcvm instructions.
#ifndef dotproduct
#define dotproduct(v1,v2) ((vector)(v1)*(vector)(v2))
#endif
vector(vector v1, vector v2) crossproduct = #0; // Small helper function to calculate the crossproduct of two vectors.
float(float modidx, string framename) frameforname = #276; // Looks up a framegroup from a model by name, avoiding the need for hardcoding. Returns -1 on error.
float(float modidx, float framenum) frameduration = #277; // Retrieves the duration (in seconds) of the specified framegroup.
void(optional entity ent, optional vector neworigin) touchtriggers = #279; // Triggers a touch events between self and every SOLID_TRIGGER entity that it is in contact with. This should typically just be the triggers touch functions. Also optionally updates the origin of the moved entity.
string(float modidx, float framenum) frametoname = #284; 
float(string name) checkcommand = #294; // Checks to see if the supplied name is a valid command, cvar, or alias. Returns 0 if it does not exist.
void(entity e, float mdlindex) setmodelindex = #333; // Sets a model by precache index instead of by name. Otherwise identical to setmodel.
string(float mdlindex) modelnameforindex = #334; // Retrieves the name of the model based upon a precache index. This can be used to reduce csqc network traffic by enabling model matching.
float(string effectname) particleeffectnum = #335; // Precaches the named particle effect. If your effect name is of the form 'foo.bar' then particles/foo.cfg will be loaded by the client if foo.bar was not already defined.
// Different engines will have different particle systems, this specifies the QC API only.
void(float effectnum, entity ent, vector start, vector end) trailparticles = #336; // Draws the given effect between the two named points. If ent is not world, distances will be cached in the entity in order to avoid framerate dependancies. The entity is not otherwise used.
void(float effectnum, vector origin, optional vector dir, optional float count) pointparticles = #337; // Spawn a load of particles from the given effect at the given point traveling or aiming along the direction specified. The number of particles are scaled by the count argument.
void(string s, ...) print = #339; // Unconditionally print on the local system's console, even in ssqc (doesn't care about the value of the developer cvar).
float(entity ent) wasfreed = #353; // Quickly check to see if the entity is currently free. This function is only valid during the two-second non-reuse window, after that it may give bad results. Try one second to make it more robust.
entity(entity from, optional entity to) copyentity = #400; // Copies all fields from one entity to another.
entity(.string field, string match, optional .entity chainfield) findchain = #402; 
entity(.float fld, float match, optional .entity chainfield) findchainfloat = #403; 
void(vector org, optional float count) te_gunshot = #418; 
void(vector org) te_spike = #419; 
void(vector org) te_superspike = #420; 
void(vector org) te_explosion = #421; 
void(vector org) te_tarexplosion = #422; 
void(vector org) te_wizspike = #423; 
void(vector org) te_knightspike = #424; 
void(vector org) te_lavasplash = #425; 
void(vector org) te_teleport = #426; 
void(vector org, float color, float colorlength) te_explosion2 = #427; 
void(entity own, vector start, vector end) te_lightning1 = #428; 
void(entity own, vector start, vector end) te_lightning2 = #429; 
void(entity own, vector start, vector end) te_lightning3 = #430; 
void(entity own, vector start, vector end) te_beam = #431; 
void(vector dir) vectorvectors = #432; 
float(entity e, float s) getsurfacenumpoints = #434; 
vector(entity e, float s, float n) getsurfacepoint = #435; 
vector(entity e, float s) getsurfacenormal = #436; 
string(entity e, float s) getsurfacetexture = #437; 
float(entity e, vector p) getsurfacenearpoint = #438; 
vector(entity e, float s, vector p) getsurfaceclippedpoint = #439; 
float(string s) tokenize = #441; 
string(float n) argv = #442; 
float() argc = #0; 
void(entity e, entity tagentity, string tagname) setattachment = #443; 
string(string cvarname) cvar_string = #448;
entity(entity start, .float fld, float match) findflags = #449; 
entity(.float fld, float match, optional .entity chainfield) findchainflags = #450; 
entity(float entnum) edict_num = #459; 
strbuf() buf_create = #460; 
void(strbuf bufhandle) buf_del = #461; 
float(strbuf bufhandle) buf_getsize = #462; 
void(strbuf bufhandle_from, strbuf bufhandle_to) buf_copy = #463; 
void(strbuf bufhandle, float sortprefixlen, float backward) buf_sort = #464; 
string(strbuf bufhandle, string glue) buf_implode = #465; 
string(strbuf bufhandle, float string_index) bufstr_get = #466; 
void(strbuf bufhandle, float string_index, string str) bufstr_set = #467; 
float(strbuf bufhandle, string str, float order) bufstr_add = #468; 
void(strbuf bufhandle, float string_index) bufstr_free = #469; 
float(float s) asin = #471; 
float(float c) acos = #472; 
float(float t) atan = #473; 
float(float c, float s) atan2 = #474; 
float(float a) tan = #475; 
float(string s) strlennocol = #476; // Returns the number of characters in the string after any colour codes or other markup has been parsed.
string(string s) strdecolorize = #477; // Flattens any markup/colours, removing them from the string.
string(float uselocaltime, string format, ...) strftime = #478; 
float(string s, string separator1, ...) tokenizebyseparator = #479; 
string(string s) strtolower = #480; 
string(string s) strtoupper = #481; 
string(string s) cvar_defstring = #482; 
void(vector origin, string sample, float volume, float attenuation) pointsound = #483; 
string(string search, string replace, string subject) strreplace = #484; 
string(string search, string replace, string subject) strireplace = #485; 
vector(entity e, float s, float n, float a) getsurfacepointattribute = #486; 
float(float caseinsensitive, string s, ...) crc16 = #494; 
float(string name) cvar_type = #495; 
float() numentityfields = #496; // Gives the number of named entity fields. Note that this is not the size of an entity, but rather just the number of unique names (ie: vectors use 4 names rather than 3).
float(string fieldname) findentityfield = #0; // Find a field index by name.
typedef .__variant field_t;
field_t(float fieldnum) entityfieldref = #0; // Returns a field value that can be directly used to read entity fields. Be sure to validate the type with entityfieldtype before using.
string(float fieldnum) entityfieldname = #497; // Retrieves the name of the given entity field.
float(float fieldnum) entityfieldtype = #498; // Provides information about the type of the field specified by the field num. Returns one of the EV_ values.
string(float fieldnum, entity ent) getentityfieldstring = #499; 
float(float fieldnum, entity ent, string s) putentityfieldstring = #500; 
string(string filename, optional float makereferenced) whichpack = #503; // Returns the pak file name that contains the file specified. progs/player.mdl will generally return something like 'pak0.pak'. If makereferenced is true, clients will automatically be told that the returned package should be pre-downloaded and used, even if allow_download_refpackages is not set.
string(string in) uri_escape = #510; 
string(string in) uri_unescape = #511; 
float(entity ent) num_for_edict = #512; 
float(string uril, float id, optional string postmimetype, optional string postdata) uri_get = #513; 
float(string str) tokenize_console = #514; // Tokenize a string exactly as the console's tokenizer would do so. The regular tokenize builtin became bastardized for convienient string parsing, which resulted in a large disparity that can be exploited to bypass checks implemented in a naive SV_ParseClientCommand function, therefore you can use this builtin to make sure it exactly matches.
float(float idx) argv_start_index = #515; // Returns the character index that the tokenized arg started at.
float(float idx) argv_end_index = #516; // Returns the character index that the tokenized arg stopped at.
void(strbuf strbuf, string pattern, string antipattern) buf_cvarlist = #517; // Populates the strbuf with a list of known cvar names.
string(string cvarname) cvar_description = #518; // Retrieves the description of a cvar, which might be useful for tooltips or help files. This may still not be useful.
float(optional float timetype) gettime = #519; 
float(float v, optional float base) log = #532; // Determines the logarithm of the input value according to the specified base. This can be used to calculate how much something was shifted by.
void(...) callfunction = #605; // Invokes the named function. The function name is always passed as the last parameter and must always be present. The others are passed to the named function as-is
float(string s) isfunction = #607; // Returns true if the named function exists and can be called with the callfunction builtin.
float(entity e, string s, optional float offset) parseentitydata = #613; // Reads a single entity's fields into an already-spawned entity. s should contain field pairs like in a saved game: {\,foo1\, \,bar\, \,foo2\, \,5\
string(string fmt, ...) sprintf = #627; 
float(entity e, float s) getsurfacenumtriangles = #628; 
vector(entity e, float s, float n) getsurfacetriangle = #629; 
string(string digest, string data, ...) digest_hex = #639; 
