/*
 * SersApplication.cpp
 *
 *  Created on: 2019��6��15��
 *      Author: root
 */

#include "SersApplication.hpp"

namespace Sers {

	AutoResetEvent SersApplication::mEventOnstop;

	ConcurrentQueue<FuncOnstop> SersApplication::actionsOnstop;

	bool SersApplication::isRunning=true;

} /* namespace Sers */
