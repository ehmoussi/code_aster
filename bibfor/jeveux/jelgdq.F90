! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine jelgdq(nomlu, rlong, nbsv)
! BUT:
!   DETERMINER LA LONGUEUR DES SEGMENTS DE VALEURS STOCKES SUR LA BASE
!   ET LE NOMBRE DE SEGMENT DE VALEURS ASSOCIES A L'OBJET NOMLU
!
!  IN    NOMLU : NOM DE L'OBJET
!  OUT   RLONG : CUMUL DES TAILLES EN OCTETS DES OBJETS ASSOCIES
!  OUT   NBSV  : NOMBRE DE SEGMENTS DE VALEURS ASSOCIES
!
!
! ----------------------------------------------------------------------
    implicit none
#include "jeveux_private.h"
#include "asterfort/jjallc.h"
#include "asterfort/jjlide.h"
#include "asterfort/jjvern.h"
#include "asterfort/utmess.h"
    character(len=*) :: nomlu
    real(kind=8) :: rlong
    integer :: nbsv
!     ------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
    integer :: n
    parameter  ( n = 5 )
    integer :: jltyp, jlong, jdate, jiadd, jiadm, jlono, jhcod, jcara, jluti
    integer :: jmarq
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &                 jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
!
    integer :: jgenr, jtype, jdocu, jorig, jrnom
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
!
    integer :: ipgc, kdesma(2), lgd, lgduti, kposma(2), lgp, lgputi
    common /iadmje/  ipgc,kdesma,   lgd,lgduti,kposma,   lgp,lgputi
    integer :: iclas, iclaos, iclaco, idatos, idatco, idatoc
    common /iatcje/  iclas ,iclaos , iclaco , idatos , idatco , idatoc
!     ------------------------------------------------------------------
    integer :: ivnmax, iddeso, idiadd, idlono, idnum
    parameter    ( ivnmax = 0 , iddeso = 1 , idiadd = 2  ,&
     &               idlono = 8  ,idnum  = 10 )
!     ------------------------------------------------------------------
    character(len=32) :: noml32
    integer :: ipgcex, icre, iret, ic, id, ibacol, k, ix
    integer :: ltypi, ixlono, ixiadd, iblono, nmax
!
    ipgcex = ipgc
    ipgc = -2
    noml32 = nomlu
    rlong = 0.0d0
    nbsv = 0
    icre = 0
    iret = 0
    call jjvern(noml32, icre, iret)
!
    if (iret .eq. 0) then
        call utmess('F', 'JEVEUX_26', sk=noml32(1:24))
!
    else if (iret .eq. 1) then
        ic = iclaos
        id = idatos
        rlong = lono(jlono(ic)+id)*ltyp(jltyp(ic)+id)
        nbsv = nbsv + 1
!
    else if (iret .eq. 2) then
        ic = iclaco
        call jjallc(iclaco, idatco, 'L', ibacol)
        id = iszon(jiszon + ibacol + iddeso )
        ixlono = iszon(jiszon + ibacol + idlono )
        ixiadd = iszon(jiszon + ibacol + idiadd )
        rlong = idnum*ltyp(jltyp(ic)+id)
        nbsv = nbsv + 1
!
! --------OBJETS ATTRIBUTS DE COLLECTION
!
        do 20 k = 1, idnum
            ix = iszon( jiszon + ibacol + k )
            if (ix .gt. 0) then
                rlong = rlong + lono(jlono(ic)+ix)*ltyp(jltyp(ic)+ix)
                nbsv = nbsv + 1
            endif
20      continue
!
! ------- CAS D'UNE COLLECTION DISPERSEE
!
        if (ixiadd .ne. 0) then
            nmax = iszon(jiszon + ibacol+ivnmax)
            ltypi = ltyp(jltyp(ic)+id)
            if (ixlono .ne. 0) then
                nmax = iszon(jiszon + ibacol+ivnmax)
                iblono = iadm (jiadm(ic) + 2*ixlono-1)
                do 10 k = 1, nmax
                    rlong = rlong + iszon(jiszon+iblono-1+k)*ltypi
                    nbsv = nbsv + 1
10              continue
            else
                rlong = rlong + nmax*lono(jlono(ic)+id)*ltypi
                nbsv = nbsv + 1
            endif
        endif
!
        call jjlide('JEIMPA', noml32(1:24), 2)
    endif
    ipgc = ipgcex
end subroutine
