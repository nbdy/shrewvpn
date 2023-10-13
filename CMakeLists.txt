#
# Shrew Soft VPN / IKE Tools
# Cross Platform Make File
#
# author : Matthew Grooms
#        : mgrooms@shrew.net
#        : Copyright 2012, Shrew Soft Inc
#
cmake_minimum_required(VERSION 3.5)
project(shrewvpn)

if(COMMAND cmake_policy)
	cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)

find_package(BISON 2.4.1 REQUIRED)
find_package(FLEX 2.5.35 REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(Threads REQUIRED)

#
# Unix Target Constants
#

add_definitions(-DUNIX -DOPENSSL_API_COMPAT=0x10100000L)

include(CheckCSourceCompiles)
include(CheckLibraryExists)

include_directories(source/)

set(RELVER "2.2.1")

add_subdirectory(source/iked)
add_subdirectory(source/ikec)
add_subdirectory(source/libike)
add_subdirectory(source/libip)
add_subdirectory(source/libidb)
add_subdirectory(source/libith)
add_subdirectory(source/liblog)
add_subdirectory(source/libpfk)

set(SEARCH_INC /usr/local/include /usr/include)
set(SEARCH_LIB /usr/local/lib /usr/lib)
set(SEARCH_BIN /usr/local/bin /usr/pkg/bin /usr/bin)
set(SEARCH_SYS /usr/local /usr/share /usr)

#
# Apple OSX Target Constants
#

if(APPLE)
	set(CMAKE_OSX_ARCHITECTURES "x86_64")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-deprecated-declarations")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")
endif(APPLE)

#
# Path Option Checks
#

if(NOT EXISTS ${CMAKE_INSTALL_PREFIX})
	set(CMAKE_INSTALL_PREFIX "/usr")
endif(NOT EXISTS ${CMAKE_INSTALL_PREFIX})

message(STATUS "Using install prefix ${CMAKE_INSTALL_PREFIX} ...")

# etc install path

if(ETCDIR)
	set(PATH_ETC ${ETCDIR})
else(ETCDIR)
	if(EXISTS ${CMAKE_INSTALL_PREFIX}/etc)
		set(PATH_ETC "${CMAKE_INSTALL_PREFIX}/etc")
	else(EXISTS ${CMAKE_INSTALL_PREFIX}/etc)
		set(PATH_ETC "/etc")
	endif(EXISTS ${CMAKE_INSTALL_PREFIX}/etc)
endif(ETCDIR)

message(STATUS "Using etc install path ${PATH_ETC} ...")

# bin install path

if(BINDIR)
	set(PATH_BIN ${BINDIR} )
else(BINDIR)
	if(EXISTS ${CMAKE_INSTALL_PREFIX}/bin)
		set(PATH_BIN "${CMAKE_INSTALL_PREFIX}/bin" )
	else(EXISTS ${CMAKE_INSTALL_PREFIX}/bin)
		set(PATH_LIB "/usr/bin" )
	endif(EXISTS ${CMAKE_INSTALL_PREFIX}/bin)
endif( BINDIR )

message(STATUS "Using bin install path ${PATH_BIN} ...")

# sbin install path

if(SBINDIR)
	set(PATH_SBIN ${SBINDIR})
else(SBINDIR)
	if(EXISTS ${CMAKE_INSTALL_PREFIX}/sbin)
		set(PATH_SBIN "${CMAKE_INSTALL_PREFIX}/sbin" )
	else(EXISTS ${CMAKE_INSTALL_PREFIX}/sbin)
		set(PATH_SBIN "/usr/sbin" )
	endif(EXISTS ${CMAKE_INSTALL_PREFIX}/sbin)
endif(SBINDIR)

message(STATUS "Using sbin install path ${PATH_SBIN} ...")

# lib install path

if( LIBDIR )
	set(PATH_LIB ${LIBDIR} )
else( LIBDIR )
	if( EXISTS ${CMAKE_INSTALL_PREFIX}/lib )
		set(PATH_LIB "${CMAKE_INSTALL_PREFIX}/lib" )
	else( EXISTS ${CMAKE_INSTALL_PREFIX}/lib )
		set(PATH_LIB "/usr/lib" )
	endif( EXISTS ${CMAKE_INSTALL_PREFIX}/lib )
endif( LIBDIR )

message(STATUS "Using lib install path ${PATH_LIB} ..." )

# man install path

if( MANDIR )
	set(PATH_MAN ${MANDIR} )
else( MANDIR )
	find_path(PATH_MAN NAMES "man" PATHS ${SEARCH_SYS} NO_DEFAULT_PATH )
	if( PATH_MAN )
		set(PATH_MAN "${PATH_MAN}/man" )
	else( PATH_MAN )
		set(PATH_MAN "${CMAKE_INSTALL_PREFIX}/man" )
	endif( PATH_MAN )
endif( MANDIR )

message(STATUS "Using man install path ${PATH_MAN} ...")

if(KRNINC)
	set(INC_KERNEL_DIR ${KRNINC} )
	message(STATUS "Using kernel include path ${INC_KERNEL_DIR} ...")
endif(KRNINC)

if(FUNC_LIB_TIMEDLOCK)
	add_definitions( -DOPT_TIMEDLOCK)
endif(FUNC_LIB_TIMEDLOCK)

find_program(
	PATH_BIN_FLEX
	NAMES "flex"
	PATHS ${SEARCH_BIN} )

if( NOT PATH_BIN_FLEX )

	message(
		FATAL_ERROR
		"Unable to locate required binary : flex" )

endif( NOT PATH_BIN_FLEX )
		
message(
	STATUS 
	"Using binary ${PATH_BIN_FLEX} ..." )

find_program(
	PATH_BIN_BISON
	NAMES "bison"
	PATHS ${SEARCH_BIN} )

if( NOT PATH_BIN_BISON )

	message(
		FATAL_ERROR
		"Unable to locate required binary : bison" )

endif( NOT PATH_BIN_BISON )
		
message(
	STATUS 
	"Using binary ${PATH_BIN_BISON} ..." )

find_path(
	PATH_INC_NETIPSEC
	NAMES "ipsec.h"
	PATHS "/usr/include/netipsec" )

if( PATH_INC_NETIPSEC )

	add_definitions( -DOPT_NETIPSEC )

endif( PATH_INC_NETIPSEC )

find_library(
	PATH_LIB_RT
	NAMES "rt"
	PATHS ${SEARCH_LIB} )

find_path(
	PATH_INC_PFKEYV2
	NAMES "net/pfkeyv2.h" "linux/pfkeyv2.h"
	PATHS ${SEARCH_INC} ${INC_KERNEL_DIR} )

if( NOT PATH_INC_PFKEYV2 )

	message(
		FATAL_ERROR
		"Unable to locate system pfkeyv2 include file" )

endif( NOT PATH_INC_PFKEYV2 )

#
# Build Option Checks
#

OPTION(DEBUG   "include Debug Symbol support")
OPTION(NATT    "include NAT Traversal support" ON)
OPTION(LDAP    "include LDAP Authentication support")
OPTION(QTGUI   "include Client QT GUI support")
OPTION(TESTS   "include library test programs")
OPTION(ETCDIR  "custom etc install path")
OPTION(BINDIR  "custom bin install path")
OPTION(SBINDIR "custom sbin install path")
OPTION(LIBDIR  "custom library install path")
OPTION(MANDIR  "custom man page install path")

# Debug Symbols Option

if(DEBUG)
	add_definitions( -g )
endif(DEBUG)

# NAT Traversion option

if( NATT )
	if( NOT APPLE )
		check_c_source_compiles(
			"
			#ifdef __linux__
			# include <inttypes.h>
			# include <linux/pfkeyv2.h>
			#else
			# include <sys/types.h>
			# include <net/pfkeyv2.h>
			#endif

			int main()
			{
				struct sadb_x_nat_t_type test;
				return 0;
			}
			"
			NATT_FOUND )

	else( NOT APPLE )
		set(NATT_FOUND TRUE)
	endif( NOT APPLE )

	if( NOT NATT_FOUND )
		message(FATAL_ERROR "Unable to locate required NAT-T pfkey structures")
	endif( NOT NATT_FOUND )

	# success

	message(STATUS "Enabled NAT Traversal support ...")
	add_definitions( -DOPT_NATT )
endif( NATT )

# LDAP support option

if( LDAP )

	# ldap include

	find_path(
		PATH_INC_LDAP
		NAMES "ldap.h"
		PATHS ${SEARCH_INC} )

	if( NOT PATH_INC_LDAP )

		message(
			FATAL_ERROR
			"Unable to locate LDAP include file" )

	endif( NOT PATH_INC_LDAP )

	# ldap libraries

	find_library(
		PATH_LIB_LDAP
		NAMES "ldap"
		PATHS ${SEARCH_LIB} )

	find_library(
		PATH_LIB_LBER
		NAMES "lber"
		PATHS ${SEARCH_LIB} )

	if( NOT PATH_LIB_LDAP OR NOT PATH_LIB_LBER )

		message(
			FATAL_ERROR
			"Unable to locate LDAP library file" )

	endif( NOT PATH_LIB_LDAP OR NOT PATH_LIB_LBER )

	# success

	message( 
		STATUS
		"Enabled LDAP Authentication support ..." )

	add_definitions( -DOPT_LDAP )

endif( LDAP )

# Client GUI option

if( QTGUI )

	add_definitions( -DQT_THREAD_SUPPORT )

	find_package(
		Qt5
		COMPONENTS QtCore QtGui REQUIRED )

	if( NOT QT_QTGUI_FOUND )

		message(
			FATAL_ERROR
			"Unable to locate required package : QT" )

	endif( NOT QT_QTGUI_FOUND )
		
	# success

	message(
		STATUS 
		"Enabled Client QT GUI support ..." )

	if( APPLE )

		add_subdirectory( source/libqt )

	endif( APPLE )

	add_subdirectory( source/qikea )
	add_subdirectory( source/qikec )

endif( QTGUI )

# Library Test Programs

if( TESTS )

	message(
		STATUS 
		"Building library test programs ..." )

	add_subdirectory( source/test_ith )

endif( TESTS )
