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

subroutine jeimpr(unit, clas, cmess)
    implicit none
#include "jeveux_private.h"
    integer :: unit
    character(len=*) :: clas, cmess
! ----------------------------------------------------------------------
! IMPRESSION DU REPERTOIRE D'UNE OU PLUSIEURS CLASSES
!
! IN  UNIT  : NUMERO D'UNITE LOGIQUE ASSOCIE AU FICHIER D'IMPRESSION
! IN  CLAS   : NOM DE LA CLASSE ASSOCIEE ( ' ' POUR TOUTES LES CLASSES )
! IN  CMESS  : MESSAGE D'INFORMATION
!
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, iiadd, iibas, iibdy, ilong, ilono, iltyp
    integer :: j, jcara, jdate, jdocu, jgenr, jhcod, jiadd
    integer :: jiadm, jlong, jlono, jltyp, jluti, jmarq, jorig
    integer :: jrnom, jtype, k, n, ncla1, ncla2
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &                 jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
!
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
!
    integer :: nrhcod, nremax, nreuti
    common /icodje/  nrhcod(n) , nremax(n) , nreuti(n)
!
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
! ----------------------------------------------------------------------
    character(len=1) :: kclas, cgenr, ctype, clasi
    character(len=32) :: crnom
! DEB ------------------------------------------------------------------
!
    kclas = clas ( 1: min(1,len(clas)))
    if (unit .le. 0) goto 9999
    if (kclas .eq. ' ') then
        ncla1 = 1
        ncla2 = index ( classe , '$' ) - 1
        if (ncla2 .lt. 0) ncla2 = n
    else
        ncla1 = index ( classe , kclas)
        ncla2 = ncla1
    endif
    do 10 i = ncla1, ncla2
        clasi = classe(i:i)
        if (clasi .ne. ' ') then
            write (unit,'(4A)' ) ('---------------------',k=1,4)
            write (unit,'(2A)' )&
     &          '------     CATALOGUE CLASSE ',clasi     ,&
     &          '------    ', cmess(1:min(72,len(cmess)))
            write (unit,'(4A)' ) ('---------------------',k=1,4)
            do 5 j = 1, nremax(i)
                crnom = rnom(jrnom(i)+j)
                if (crnom(1:1) .eq. '?') goto 5
                if (mod(j,25) .eq. 1) then
                    write ( unit , '(/,A,A/)' )&
     &      '--- NUM  -------------- NOM ---------------- G T L- --LONG'&
     &      ,'--- -LOTY- -IADD- --------KADM------- --------KDYN-------'
                endif
                cgenr = genr(jgenr(i)+j)
                ctype = type(jtype(i)+j)
                iltyp = ltyp(jltyp(i)+j)
                ilong = long(jlong(i)+j)
                ilono = lono(jlono(i)+j)
                iiadd = iadd(jiadd(i)+2*j-1)
                iibas = iadm(jiadm(i)+2*j-1)
                iibdy = iadm(jiadm(i)+2*j )
                write(unit , 1001) j,crnom,cgenr,ctype,iltyp, ilong,&
                ilono,iiadd,iibas,iibdy
 5          continue
            write ( unit , '(/)' )
        endif
10  end do
9999  continue
    1001 format(i8,2x,a,'  -',2(a,'-'),i2,1x,i8,1x,i7,i7,i20,i20)
! FIN ------------------------------------------------------------------
end subroutine
