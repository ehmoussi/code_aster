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

subroutine limacx(char, motfac, ndim, nzoco)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    character(len=8) :: char
    character(len=16) :: motfac
    integer :: nzoco, ndim
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEM - LECTURE DONNEES)
!
! LECTURE DES FISSURES EN CONTACT
!
! ----------------------------------------------------------------------
!
!
! IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
! IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
! IN  NDIM   : NOMBRE DE DIMENSIONS DU PROBLEME
! IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
!
!
!
!
    character(len=24) :: defico
    integer :: iocc, ibid
    character(len=8) :: fiss
    character(len=24) :: xfimai, ndimco
    integer :: jfimai, jdim
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    defico = char(1:8)//'.CONTACT'
!
! --- ACCES AUX STRUCTURES DE DONNEES DE CONTACT
!
    ndimco = defico(1:16)//'.NDIMCO'
    call jeveuo(ndimco, 'E', jdim)
!
! --- CREATION DES SD
!
    xfimai = defico(1:16)//'.XFIMAI'
!
! --- CREATION DES STRUCTURE DE DONNEES DE CONTACT
!
    call wkvect(xfimai, 'G V K8', nzoco, jfimai)
    zi(jdim+1-1) = ndim
    zi(jdim+2-1) = nzoco
!
! --- LECTURE DES FISSURES EN CONTACT
!
    do 10 iocc = 1, nzoco
        call getvid(motfac, 'FISS_MAIT', iocc=iocc, scal=fiss, nbret=ibid)
        zk8(jfimai-1+iocc) = fiss
10  end do
!
    call jedema()
end subroutine
