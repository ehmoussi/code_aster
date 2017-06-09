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

subroutine jxlibd(idco, idos, ic, iaddi, lonoi)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "asterf_types.h"
#include "jeveux_private.h"
#include "asterfort/jxecrb.h"
#include "asterfort/jxlirb.h"
    integer :: idco, idos, ic, iaddi(2), lonoi
! ----------------------------------------------------------------------
! MARQUE LA PLACE DISQUE EN VUE D'UNE RECUPERATION ULTERIEURE
! L'IDENTIFICATEUR EST MIS NEGATIF
! IN  IDCO  : IDENTIFICATEUR DE COLLECTION
! IN  IDOS  : IDENTIFICATEUR D'OBJET SIMPLE OU D'OBJET DE COLLECTION
! IN  IC     : CLASSE ASSOCIEE A L'OBJET JEVEUX
! IN  IADDI  : ADRESSE DISQUE DE L'OBJET REPERE PAR ID
! IN  LONOI  : LONGUEUR EN OCTETS DE L'OBJET
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
!     ------------------------------------------------------------------
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, jiecr, jusadi, n, nbgros, nblent
    integer :: nblim, nbpeti
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    integer :: nblmax, nbluti, longbl, kitlec, kitecr, kiadm, iitlec, iitecr
    integer :: nitecr, kmarq
    common /ificje/  nblmax(n) , nbluti(n) , longbl(n) ,&
     &                 kitlec(n) , kitecr(n) ,             kiadm(n) ,&
     &                 iitlec(n) , iitecr(n) , nitecr(n) , kmarq(n)
    aster_logical :: litlec
    common /lficje/  litlec(n)
    common /jusadi/  jusadi(n)
    common /inbdet/  nblim(n),nbgros(n),nbpeti(n)
!     ------------------------------------------------------------------
    integer :: kadd, ladd, lgbl
    aster_logical :: lpetit, lrab
! DEB ------------------------------------------------------------------
    kadd = iaddi(1)
    ladd = iaddi(2)
    lpetit = ( ( iusadi(jusadi(ic)+3*kadd-2) .eq. 0 .and. iusadi(jusadi(ic)+3*kadd-1) .eq. 0 ) )
    lgbl = 1024*longbl(ic)*lois
!
    if (lpetit) then
!
! ----- PETIT OBJET
!
        if (kadd .eq. iitlec(ic)) then
            jiecr = (jk1zon+kitlec(ic)+ladd)/lois+1
            iszon(jiecr-3) = -idco
            iszon(jiecr-2) = -idos
            litlec(ic) = .true.
        else if (kadd .eq. iitecr(ic)) then
            jiecr = (jk1zon+kitecr(ic)+ladd)/lois+1
            iszon(jiecr-3) = -idco
            iszon(jiecr-2) = -idos
        else
            if (litlec(ic)) then
                call jxecrb(ic, iitlec(ic), kitlec(ic)+1, lgbl, 0,&
                            0)
            endif
            call jxlirb(ic, kadd, kitlec(ic)+1, lgbl)
            jiecr = (jk1zon+kitlec(ic)+ladd)/lois+1
            iszon(jiecr-3) = -idco
            iszon(jiecr-2) = -idos
            iitlec(ic) = kadd
            litlec(ic) = .true.
        endif
        iusadi(jusadi(ic)+3*kadd) = iusadi(jusadi(ic)+3*kadd) + 1
        nbpeti(ic) = nbpeti(ic) + 1
    else
!
! ----- GROS  OBJET
!
        nblent = lonoi / lgbl
        lrab = ( mod (lonoi , lgbl) .ne. 0 )
        do 10 i = 1, nblent
            iusadi(jusadi(ic)+3*(kadd+i-1)-2) = -idco
            iusadi(jusadi(ic)+3*(kadd+i-1)-1) = -idos
 10     continue
        if (lrab) then
            iusadi(jusadi(ic)+3*(kadd+nblent)-2) = -idco
            iusadi(jusadi(ic)+3*(kadd+nblent)-1) = -idos
        endif
    endif
    nbgros(ic) = nbgros(ic) + 1
! FIN ------------------------------------------------------------------
end subroutine
