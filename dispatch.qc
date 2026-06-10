// typedef void(float, float, float) myfunctype_t;
// const float dispatch_count;
// const string dispatch_names[64] = {"a","b"};
// const myfunctype_t dispatch_funcs[64];
// // void register_func(string name, myfunctype_t f) {
// // 	dispatch_names[dispatch_count] = name;
// // 	dispatch_funcs[dispatch_count] = f;
// // 	dispatch_count++;
// // }
// myfunctype_t lookup_func(string name) {
// 	float i;
// 	for (i = 0; i < dispatch_count; i++)
// 		if (dispatch_names[i] == name)
// 			return dispatch_funcs[i];
// 	return __NULL__;
// }


// typedef void(float, float, float) myfunctype_t;
// .float dispatch_count = 0;
// .string dispatch_names[64];
// .myfunctype_t dispatch_funcs[64];
// void register_func(string name, myfunctype_t f) {
// 	self.dispatch_names[self.dispatch_count] = name;
// 	self.dispatch_funcs[self.dispatch_count] = f;
// 	self.dispatch_count++;
// }
// myfunctype_t lookup_func(string name) {
// 	float i;
// 	for (i = 0; i < self.dispatch_count; i++)
// 		if (self.dispatch_names[i] == name)
// 			return self.dispatch_funcs[i];
// 	return __NULL__;
// }


// void() test2 {
// 	register_func("function3", function3);
	
// 	myfunctype_t fp = lookup_func(function_name);
// 	if (fp) fp(param1, param2, param3);
// }
