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

/* disable the message "line too long" because the code is generated  */
/* aslint: disable=C3001 */

#include "definition.h"

#ifndef DEFINITION_PT_H
#define DEFINITION_PT_H

/* Appels et signatures avec strlen en fin de liste */
#ifdef _STRLEN_AT_END
#define DEF_P_PPPPSPSP(NAME,a,b,c,d,e,le,f,g,lg,h)               (NAME)(a,b,c,d,e,f,g,h,le,lg)
#define CALL_P_PPPPSPSP(NAME,a,b,c,d,e,f,g,h)                    (NAME)(a,b,c,d,e,f,g,h,strlen(e),strlen(g))
#define DEF_P_PPPPSPPP(NAME,a,b,c,d,e,le,f,g,h)               (NAME)(a,b,c,d,e,f,g,h,le)
#define CALL_P_PPPPSPPP(NAME,a,b,c,d,e,f,g,h)                 (NAME)(a,b,c,d,e,f,g,h,strlen(e))
#define DEF_P_PPPPPSPPSP(NAME,a,b,c,d,e,f,lf,g,h,i,li,j)               (NAME)(a,b,c,d,e,f,g,h,i,j,lf,li)
#define CALL_P_PPPPPSPPSP(NAME,a,b,c,d,e,f,g,h,i,j)                    (NAME)(a,b,c,d,e,f,g,h,i,j,strlen(f),strlen(i))
#define DEF_P_PPPPPSPPPP(NAME,a,b,c,d,e,f,lf,g,h,i,j)               (NAME)(a,b,c,d,e,f,g,h,i,j,lf)
#define CALL_P_PPPPPSPPPP(NAME,a,b,c,d,e,f,g,h,i,j)                 (NAME)(a,b,c,d,e,f,g,h,i,j,strlen(f))

#define DEFUMAT(NAME,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,ls,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K)               (NAME)(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,ls)
#define CALLUMAT(NAME,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K)                 (NAME)(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,strlen(s))

#define DEFMFRONTBEHAVIOUR(NAME,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)               (NAME)(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)
#define CALLMFRONTBEHAVIOUR(NAME,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)                 (NAME)(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)

#define DEFMFRONTSETDOUBLE(NAME,a,b,la)               (NAME)(a,b,la)
#define CALLMFRONTSETDOUBLE(NAME,a,b)                 (NAME)(a,b,strlen(a))
#define DEFMFRONTSETINTEGER(NAME,a,b,la)               (NAME)(a,b,la)
#define CALLMFRONTSETINTEGER(NAME,a,b)                 (NAME)(a,b,strlen(a))
#define DEFMFRONTSETOUTOFBOUNDSPOLICY(NAME,a)               (NAME)(a)
#define CALLMFRONTSETOUTOFBOUNDSPOLICY(NAME,a)                 (NAME)(a)

/* Appels et signatures avec strlen juste après le pointeur de chaine */
#else
#define DEF_P_PPPPSPSP(NAME,a,b,c,d,e,le,f,g,lg,h)               (NAME)(a,b,c,d,e,le,f,g,lg,h)
#define CALL_P_PPPPSPSP(NAME,a,b,c,d,e,f,g,h)                    (NAME)(a,b,c,d,e,strlen(e),f,g,strlen(g),h)
#define DEF_P_PPPPSPPP(NAME,a,b,c,d,e,le,f,g,h)               (NAME)(a,b,c,d,e,le,f,g,h)
#define CALL_P_PPPPSPPP(NAME,a,b,c,d,e,f,g,h)                 (NAME)(a,b,c,d,e,strlen(e),f,g,h)
#define DEF_P_PPPPPSPPSP(NAME,a,b,c,d,e,f,lf,g,h,i,li,j)               (NAME)(a,b,c,d,e,f,lf,g,h,i,li,j)
#define CALL_P_PPPPPSPPSP(NAME,a,b,c,d,e,f,g,h,i,j)                    (NAME)(a,b,c,d,e,f,strlen(f),g,h,i,strlen(i),j)
#define DEF_P_PPPPPSPPPP(NAME,a,b,c,d,e,f,lf,g,h,i,j)               (NAME)(a,b,c,d,e,f,lf,g,h,i,j)
#define CALL_P_PPPPPSPPPP(NAME,a,b,c,d,e,f,g,h,i,j)                 (NAME)(a,b,c,d,e,f,strlen(f),g,h,i,j)

#define DEFUMAT(NAME,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,ls,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K)               (NAME)(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,ls,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K)
#define CALLUMAT(NAME,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K)                 (NAME)(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,strlen(s),t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K)

#define DEFMFRONTBEHAVIOUR(NAME,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)               (NAME)(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)
#define CALLMFRONTBEHAVIOUR(NAME,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)                 (NAME)(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)

#define DEFMFRONTSETDOUBLE(NAME,a,b,la)               (NAME)(a,la,b)
#define CALLMFRONTSETDOUBLE(NAME,a,b)                 (NAME)(a,strlen(a),b)
#define DEFMFRONTSETINTEGER(NAME,a,b,la)               (NAME)(a,la,b)
#define CALLMFRONTSETINTEGER(NAME,a,b)                 (NAME)(a,strlen(a),b)
#define DEFMFRONTSETOUTOFBOUNDSPOLICY(NAME,a)               (NAME)(a)
#define CALLMFRONTSETOUTOFBOUNDSPOLICY(NAME,a)                 (NAME)(a)

#endif

#endif
