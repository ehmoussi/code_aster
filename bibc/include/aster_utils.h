/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

/* person_in_charge: mathieu.courtois at edf.fr */

#ifndef ASTER_UTILS_H
#define ASTER_UTILS_H

#include "aster.h"

STRING_SIZE FStrlen( char *, STRING_SIZE );
char * MakeCStrFromFStr( char *, STRING_SIZE );
char * MakeFStrFromCStr( char *, STRING_SIZE );
void   CopyCStrToFStr( char *, char *, STRING_SIZE );
char * MakeTabFStr( int, STRING_SIZE );
void   SetTabFStr( char *, int, char *, STRING_SIZE );
void   BlankStr( char *, STRING_SIZE );
char * MakeBlankFStr( STRING_SIZE );
void   FreeStr( char * );

void _check_string_length( STRING_SIZE );


extern void convc8( _IN int, _IN PyObject *, _OUT ASTERDOUBLE *);
extern int conv_un_c8( _IN PyObject *, _OUT ASTERDOUBLE *);
extern void convr8( _IN int, _IN PyObject *, _OUT ASTERDOUBLE *);
extern void convert( _IN int, _IN PyObject *, _OUT ASTERINTEGER *);
extern void convertxt( _IN int, _IN PyObject *, _OUT char *, _IN STRING_SIZE);
extern void converltx( _IN int, _IN PyObject *, _OUT char *, _IN STRING_SIZE);


extern PyObject * MakeTupleString(long, char *, STRING_SIZE, ASTERINTEGER *);
extern PyObject * MakeListString(long, char *, STRING_SIZE);
extern PyObject * MakeTupleInt(long, ASTERINTEGER *);
extern PyObject * MakeListInt(long, ASTERINTEGER *);
extern PyObject * MakeTupleFloat(long, ASTERDOUBLE *);
extern PyObject * MakeListFloat(long, ASTERDOUBLE *);

#endif
