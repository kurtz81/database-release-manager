#!/bin/bash
#------------------------------------------------
# Author(s): Geaaru, geaaru@gmail.com
# $Id$
# License: GPL 2.0
#------------------------------------------------

name="logfile"
logfile_authors="Geaaru"
logfile_creation_date="May 6, 2013"
logfile_version="0.1"
logfile_status="0"

logfile_version () {
   echo -en "Version: ${logfile_version}\n"
   return 0
}

logfile_long_help () {

   echo -en "===========================================================================\n"
   echo -en "Module [logfile]:\n"
   echo -en "Author(s): ${logfile_authors}\n"
   echo -en "Created: ${logfile_creation_date}\n"
   echo -en "Version: ${logfile_version}\n"
   echo -en "---------------------------------------------------------------------------\n"
   echo -en "\tlong_help               Show long help informations\n"
   echo -en "\tshow_help               Show command list.\n"
   echo -en "\tversion                 Show module version.\n"
   echo -en "\tinfo                    Show logfile module status.\n"
   echo -en "\treset                   Remove logfile.\n"
   echo -en "\twrite [msg]             Write a message to log file.\n"
   echo -en "---------------------------------------------------------------------------\n"
   echo -en "===========================================================================\n"

   return 0


}

logfile_show_help () {

   echo -en "===========================================================================\n"
   echo -en "Module [logfile]:\n"
   echo -en "---------------------------------------------------------------------------\n"
   echo -en "\tlong_help               Show long help informations\n"
   echo -en "\tshow_help               Show command list.\n"
   echo -en "\tversion                 Show module version.\n"
   echo -en "\tinfo                    Show logfile module status.\n"
   echo -en "\treset                   Remove logfile.\n"
   echo -en "\twrite [msg]             Write a message to log file.\n"
   echo -en "---------------------------------------------------------------------------\n"
   echo -en "===========================================================================\n"

   return 0
}



logfile_info () {

   echo -en "===========================================================================\n"
   echo -en "Module [logfile]:\n"
   echo -en "---------------------------------------------------------------------------\n"
   echo -en "Logfile = $LOGFILE\n"
   echo -en "Status  = $logfile_status\n"
   echo -en "---------------------------------------------------------------------------\n"
   echo -en "===========================================================================\n"

}

logfile_write () {

  local result=0

  # Shift first two input param
  shift 2

  local msg=$1

  _logfile_write "$msg" || $result=1

  return $result

}

logfile_reset () {

  local res=0

  if [ x$logfile_status == x"1" ] ; then

    confirmation_question "Are you sure to remove file $LOGFILE ? [y/N]"
    res=$?

    if [ $res -eq 0 ] ; then
      rm $LOGFILE || error_handled "Error on remove file $LOGFILE"
      echo -en "File $LOGFILE removed correctly.\n"
    else
      res=1
    fi

  else

    echo -en "Logging is not enable. I do nothing.\n"
    res=1

  fi

  return $res
}

##################################################################
# Internal functions
##################################################################

_logfile_write () {

  local msg=$1

  local d=`date +%Y%m%d-%H:%M:%S`

  if [ x$logfile_status != x"1" ] ; then
    # Logging not enable
    return 0
  fi

  echo -en "------------------------------------------------------\n" >> $LOGFILE || return 1
  echo -en "$d - $msg\n" >> $LOGFILE || return 1
  echo -en "------------------------------------------------------\n" >> $LOGFILE || return 1

  return 0

}

_logfile_init () {

  if [ -z "$LOGFILE" ] ; then
    logfile_status="0"
  else

    # Check if file is writable
    touch $LOGFILE || error_handled "Error on access to $LOGFILE"

    logfile_status="1"

  fi

}

# vim: syn=sh filetype=sh