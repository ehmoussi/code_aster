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

subroutine jxliro(ic, iadmi, iaddi, lso)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "asterf_types.h"
#include "jeveux_private.h"
#include "asterfort/jxdeps.h"
#include "asterfort/jxecrb.h"
#include "asterfort/jxlirb.h"
#include "asterfort/utmess.h"
    integer :: ic, iadmi, iaddi(2), lso
! ----------------------------------------------------------------------
! LECTURE D'UN SEGMENT DE VALEUR
!
! IN  IC    : NOM DE LA CLASSE
! IN  IADMI : ADRESSE MEMOIRE DU SEGMENT DE VALEURS
! IN  IADDI : ADRESSE DISQUE DU SEGMENT DE VALEURS
! IN  LSO   : LONGUEUR EN OCTET DU SEGMENT DE VALEURS
!
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: jadm, jusadi, ladm, n, nde
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
!
    integer :: nblmax, nbluti, longbl, kitlec, kitecr, kiadm, iitlec, iitecr
    integer :: nitecr, kmarq
    common /ificje/  nblmax(n) , nbluti(n) , longbl(n) ,&
     &                 kitlec(n) , kitecr(n) ,             kiadm(n) ,&
     &                 iitlec(n) , iitecr(n) , nitecr(n) , kmarq(n)
    aster_logical :: litlec
    common /lficje/  litlec(n)
    common /jusadi/  jusadi(n)
! ----------------------------------------------------------------------
    integer :: iadmo, kadd, ladd, lgbl, lso2
    aster_logical :: lpetit
    parameter      ( nde = 6)
! ----------------------------------------------------------------------
! REMARQUE : LE PARAMETER NDE EST AUSSI DEFINI DANS JXECRO
!
! DEB ------------------------------------------------------------------
    jadm = iadmi
    ladm = iszon(jiszon + jadm - 3 )
    kadd = iaddi(1)
    ladd = iaddi(2)
    lgbl = 1024*longbl(ic)*lois
    iadmo = ( jadm - 1 ) * lois + ladm + 1
    lso2 = lso
    if (mod(lso,lois) .ne. 0) lso2 = (1 + lso/lois) * lois
    lpetit = ( lso .lt. lgbl-nde*lois )
!
    if (iaddi(1) .eq. 0) then
        call utmess('F', 'JEVEUX1_59')
    else
!
! ----- RECHARGEMENTS ULTERIEURS
!
        if (lpetit) then
!
! ------- PETIT OBJET
!
            if (kadd .eq. iitlec(ic)) then
                call jxdeps(kitlec(ic)+ladd+1, iadmo, lso)
            else if (kadd .eq. iitecr(ic)) then
                call jxdeps(kitecr(ic)+ladd+1, iadmo, lso)
            else
                if (litlec(ic)) then
                    call jxecrb(ic, iitlec(ic), kitlec(ic)+1, lgbl, 0,&
                                0)
                    iusadi ( jusadi(ic) + 3*iitlec(ic)-2 ) = 0
                    iusadi ( jusadi(ic) + 3*iitlec(ic)-1 ) = 0
                endif
                call jxlirb(ic, kadd, kitlec(ic)+1, lgbl)
                call jxdeps(kitlec(ic)+1+ladd, iadmo, lso)
                iitlec(ic) = kadd
                litlec(ic) = .false.
            endif
        else
!
! ------- GROS  OBJET
!
            call jxlirb(ic, kadd, iadmo, lso2)
        endif
    endif
! FIN ------------------------------------------------------------------
end subroutine
