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

subroutine dflld2(sdlist, ifm, iechec)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dfllvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=8) :: sdlist
    integer :: ifm, iechec
!
! ----------------------------------------------------------------------
!
! OPERATEUR DEFI_LIST_INST
!
! IMPRESSION DEBUG - OPTIONS DE DECOUPE
!
! ----------------------------------------------------------------------
!
! IN  SDLIST : NOM DE LA SD RESULTAT
! IN  IFM    : UNITE LOGIQUE AFFICHAGE
!
!
!
!
    character(len=24) :: lisifr
    integer :: jlinr
    integer :: lesur
    character(len=24) :: lisesu
    integer :: jesur
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- TAILLE DES VECTEURS
!
    lesur = dfllvd('LESUR')
!
! --- ACCES SDS
!
    lisifr = sdlist(1:8)//'.LIST.INFOR'
    call jeveuo(lisifr, 'L', jlinr)
    lisesu = sdlist(1:8)//'.ECHE.SUBDR'
    call jeveuo(lisesu, 'L', jesur)
!
! --- AFFICHAGE
!
!
    if (zr(jesur-1+lesur*(iechec-1)+1) .eq. 1.d0) then
        write(ifm,*) '<DEFILISTINST> ......... MANUEL'
        write(ifm,*) '<DEFILISTINST> ............ NBRE DE'//&
     &             ' SUBDIVISIONS DEMANDEES',&
     &             nint(zr(jesur-1+lesur*(iechec-1)+2))
        if (nint(zr(jesur-1+lesur*(iechec-1)+4)) .eq. 0) then
            write(ifm,*) '<DEFILISTINST> ............ ARRET'//&
            ' DE LA SUBDIVISION QUAND LE PAS '// ' VAUT MOINS DE : ',&
            zr(jesur-1+lesur*(iechec-1)+3)
        else
            write(ifm,*) '<DEFILISTINST> ............ ARRET'//&
     &                 ' DE LA SUBDIVISION QUAND LE NIVEAU'//&
     &                 ' DE SUBDIVISION VAUT: ',&
     &                 nint(zr(jesur-1+lesur*(iechec-1)+4))
        endif
    else if (zr(jesur-1+lesur*(iechec-1)+1).eq.2.d0) then
        write(ifm,*) '<DEFILISTINST> ......... AUTOMATIQUE'
!
        if (zr(jesur-1+lesur*(iechec-1)+10) .eq. 2.d0) then
            write(ifm,*) '<DEFILISTINST> ............ EXTRAPOLATION '
        else if (zr(jesur-1+lesur*(iechec-1)+10).eq.1.d0) then
            write(ifm,*) '<DEFILISTINST> ............ COLLISION '
            write(ifm,*) '<DEFILISTINST> ............... DELTAT '//&
            ' DE LA COLLISION : ', zr(jesur-1+lesur*(iechec-1)+5)
            write(ifm,*) '<DEFILISTINST> ............... DUREE '//&
            ' DE LA DECOUPE : ', zr(jesur-1+lesur*(iechec-1)+6)
        else
            ASSERT(.false.)
        endif
    endif
!
    call jedema()
end subroutine
