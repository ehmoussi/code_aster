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

subroutine cfbord(char, noma)
    implicit none
#include "jeveux.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=8) :: char
    character(len=8) :: noma
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - LECTURE DONNEES)
!
! LECTURE DES MAILLES DE CONTACT
!
! ----------------------------------------------------------------------
!
!
! IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
! IN  NOMA   : NOM DU MAILLAGE
! IN  NOMO   : NOM DU MODELE
! IN  MOTFAC : MOT-CLE FACTEUR (VALANT 'CONTACT')
! IN  NDIM   : NOMBRE DE DIMENSIONS DU PROBLEME
! IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
! OUT LIGRET : LIGREL D'ELEMENTS TARDIFS DU CONTACT
!
!
!
!
    character(len=24) :: defico, contma
    integer ::  jmaco
    integer :: ndimg, nmaco, vali(2)
    integer :: ima, nummai, nutyp, ndimma
    integer, pointer :: typmail(:) => null()
    integer, pointer :: tmdim(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    defico = char(1:8)//'.CONTACT'
    contma = defico(1:16)//'.MAILCO'
!
! --- LECTURE DES STRUCTURES DE DONNEES
!
    call jeveuo(noma//'.TYPMAIL', 'L', vi=typmail)
    call jeveuo(contma, 'L', jmaco)
    call jeveuo('&CATA.TM.TMDIM', 'L', vi=tmdim)
!
! --- INFO SUR LE CONTACT
!
    ndimg = cfdisi(defico,'NDIM' )
    nmaco = cfdisi(defico,'NMACO' )
!
! --- VERIFICATION DE LA COHERENCE DES DIMENSIONS
!
    do 10 ima = 1, nmaco
        nummai = zi(jmaco -1 + ima)
        nutyp = typmail(nummai)
        ndimma = tmdim(nutyp)
        if (ndimma .gt. (ndimg-1)) then
            vali(1) = ndimma
            vali(2) = ndimg
            call utmess('F', 'CONTACT2_11', ni=2, vali=vali)
        endif
10  end do
!
    call jedema()
!
end subroutine
