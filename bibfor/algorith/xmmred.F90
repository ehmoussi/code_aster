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

subroutine xmmred(ndimg, depdel, depdes, lagcn, depcn,&
                  fcont, fconts, fctcn, ffrot, ffrots,&
                  ffrocn)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/cnocns.h"
#include "asterfort/cnsred.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: ndimg
    character(len=19) :: depdel, depdes, lagcn, depcn
    character(len=19) :: fcont, fconts, fctcn
    character(len=19) :: ffrot, ffrots, ffrocn
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEM - POST-TRAITEMENT)
!
! REDUCTION DU CHAMP SUR LES DDL
!
! ----------------------------------------------------------------------
!
!
! IN  NDIMG  : DIMENSION DE L'ESPACE
!
!
!
!
    character(len=8) :: ddlc(3), ddls2(4), ddls3(6), ddlt2(6), ddlt3(9)
! ----------------------------------------------------------------------
    data         ddlc  /'LAGS_C','LAGS_F1','LAGS_F2'/
    data         ddls2 /'H1X','H1Y','K1','K2'/
    data         ddls3 /'H1X','H1Y','H1Z','K1','K2','K3'/
    data         ddlt2 /'DX','DY','H1X','H1Y','K1','K2'/
    data         ddlt3 /'DX','DY','DZ','H1X','H1Y','H1Z',&
     &                    'K1','K2','K3'/
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- TRANSFORMATION DES CHAM_NO EN CHAM_NO_S
!
    call cnocns(depdel, 'V', depdes)
    call cnocns(fcont, 'V', fconts)
    call cnocns(ffrot, 'V', ffrots)
!
! --- REDUCTION SUR LES DDLS DE CONTACT
!
    call cnsred(depdes, 0, [0], ndimg, ddlc,&
                'V', lagcn)
!
! --- REDUCTION SUR LES DDLS DE SAUTS
!
    if (ndimg .eq. 3) call cnsred(depdes, 0, [0], 2*ndimg, ddls3,&
                                  'V', depcn)
    if (ndimg .eq. 2) call cnsred(depdes, 0, [0], 2*ndimg, ddls2,&
                                  'V', depcn)
!
! --- REDUCTION FORCE DE CONTACT
!
    if (ndimg .eq. 2) call cnsred(fconts, 0, [0], 3*ndimg, ddlt2,&
                                  'V', fctcn)
    if (ndimg .eq. 3) call cnsred(fconts, 0, [0], 3*ndimg, ddlt3,&
                                  'V', fctcn)
!
! --- REDUCTION FORCE DE FROTTEMENT
!
    if (ndimg .eq. 2) call cnsred(ffrots, 0, [0], 3*ndimg, ddlt2,&
                                  'V', ffrocn)
    if (ndimg .eq. 3) call cnsred(ffrots, 0, [0], 3*ndimg, ddlt3,&
                                  'V', ffrocn)
!
    call jedema()
end subroutine
