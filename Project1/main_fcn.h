

#ifndef _MAIN_FCN_H_
#define _MAIN_FCN_H_

struct ctrl_flags{
	bool main_done_cmd = 0;
	bool call_help_cmd = 0;
	bool help_rdy_cmd = 0;
	volatile bool kernel_rdy_cmd = 0;
	volatile bool help_running_cmd = 0;
	volatile bool interrupt_help_cmd = 0;
	volatile bool request_val_cmd = 0;
	volatile bool req_delivered_cmd = 0;
	
	volatile bool *kernel_rdy = &kernel_rdy_cmd;
	bool *call_help = &call_help_cmd;
	bool *help_rdy = &help_rdy_cmd;
	bool *main_done = &main_done_cmd;
	volatile bool *help_running = &help_running_cmd;
	volatile bool *interrupt_help = &interrupt_help_cmd;
	volatile bool *request_val = &request_val_cmd;
	volatile bool *request_done = &req_delivered_cmd;};

#endif // _MAIN_FCN_H_
