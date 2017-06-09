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

subroutine mmimp3(ifm, noma, iptc, jvalv, jtabf)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
!
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
    integer :: ifm
    character(len=8) :: noma
    integer :: iptc
    integer :: jvalv, jtabf
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE - IMPRESSIONS)
!
! AFFICHAGE DE LA CARTE DES ELEMENTS DE CONTACT
!
! ----------------------------------------------------------------------
!
!
! IN  IFM    : UNITE D'IMPRESSION DU MESSAGE
! IN  NOMA   : NOM DU MAILLAGE
! IN  IPTC   : NUMERO DU POINT DE CONTACT SUR TOUTE LA SURFACE
! IN  JVALV  : POINTEUR VERS LE CHAM_ELEM
! IN  JTABF  : POINTEUR VERS DEFICO(1:16)//'.CARACF'
!
!
!
!
    integer :: ztabf
    integer :: nummae, nummam
    character(len=8) :: nomesc, nommai
    real(kind=8) :: lambda
    real(kind=8) :: coefac, coefaf
    real(kind=8) :: deltat, theta
    real(kind=8) :: jeusup
    integer :: iform
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    ztabf = cfmmvd('ZTABF')
!
    lambda = zr(jvalv-1+13)
    coefac = zr(jvalv-1+16)
    coefaf = zr(jvalv-1+19)
    iform = nint(zr(jvalv-1+25))
    deltat = zr(jvalv-1+26)
    theta = zr(jvalv-1+27)
    jeusup = zr(jvalv-1+14)
!
! --- ACCES A L'ELEMENT EN COURS
!
    nummae = nint(zr(jtabf+ztabf*(iptc-1)+1))
    call jenuno(jexnum(noma//'.NOMMAI', nummae), nomesc)
    nummam = nint(zr(jtabf+ztabf*(iptc-1)+2))
    call jenuno(jexnum(noma//'.NOMMAI', nummam), nommai)
    write(ifm,1000) iptc,nomesc,nommai
!
! --- POINT DE CONTACT EN COURS
!
    write(ifm,1001)
    write(ifm,1002) lambda,coefac,coefaf,jeusup
    if (iform .eq. 2) then
        write(ifm,1003) deltat,theta
    else
        write(ifm,1004) deltat
    endif
!
! --- FORMATS AFFICHAGE
!
    1000 format (' <CONTACT>     * LA MAILLE DE CONTACT ',i5,&
     &        '(',a8,'/',a8,')')
    1001 format (' <CONTACT>        A POUR PROPRIETES')
!
    1002 format (' <CONTACT>          - LAMBDA         : ',e10.3,&
     &        ' - COEF_AUGM_CONT :  ',e10.3,&
     &        ' - COEF_AUGM_FROT :  ',e10.3,&
     &        ' - JEU SUPP.      :  ',e10.3)
!
    1003 format (' <CONTACT>          AVEC FORMULATION EN VITESSE  ',&
     &        ' - INC. DE TEMPS  :  ',e10.3,&
     &        ' - THETA          :  ',e10.3)
    1004 format (' <CONTACT>          AVEC FORMULATION EN DEPLACEMENT  ',&
     &        ' - INC. DE TEMPS  :  ',e10.3)
!
    call jedema()
!
end subroutine
