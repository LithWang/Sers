/*
 * main.c
 *
 *  Created on: 2019��3��13��
 *      Author: root
 */

//#include "Test/httpTest.h"
//#include "Test/jsonTest.h"

//#include "Sers/ServiceStation/ServiceStation.hpp"

#include "Sers/Gateway/Gateway.hpp"


int main()
{

//	LoggerTest();
	//	MqTest();

	//HttpTest();

//	JsonTest();


	Gateway_Start();
	Logger::Info("Program exited.");
	return 0;
}

