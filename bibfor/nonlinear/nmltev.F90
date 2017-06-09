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

subroutine nmltev(sderro, typevt, nombcl, levent)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: sderro
    character(len=4) :: typevt
    character(len=4) :: nombcl
    aster_logical :: levent
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (SD ERREUR)
!
! DIT SI UN EVENEMENT DE TYPE DONNE EST ACTIVE
!
! ----------------------------------------------------------------------
!
!
! IN  SDERRO : SD GESTION DES ERREURS
! IN  TYPEVT : TYPE EVENEMENT
!               'EVEN' - EVENEMENT SIMPLE
!               'ERRI' - EVENEMENT DE TYPE ERREUR IMMEDIATE
!               'ERRC' - EVENEMENT DE TYPE ERREUR A CONVERGENCE
!               'CONV' - EVENEMENT POUR DETERMINER LA CONVERGENCE
! IN  NOMBCL : NOM DE LA BOUCLE
!               'RESI' - RESIDUS D'EQUILIBRE
!               'NEWT' - BOUCLE DE NEWTON
!               'FIXE' - BOUCLE DE POINT FIXE
!               'INST' - BOUCLE SUR LES PAS DE TEMPS
! OUT LEVENT : .TRUE. SI AU MOINS UN EVENT EST ACTIVE
!
!
!
!
    integer :: ieven, zeven
    character(len=24) :: errinf
    integer :: jeinfo
    character(len=24) :: erraac, erreni
    integer :: jeeact, jeeniv
    integer :: icode
    character(len=9) :: teven
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    levent = .false.
!
! --- ACCES SD
!
    errinf = sderro(1:19)//'.INFO'
    call jeveuo(errinf, 'L', jeinfo)
    zeven = zi(jeinfo-1+1)
!
    erraac = sderro(1:19)//'.EACT'
    erreni = sderro(1:19)//'.ENIV'
    call jeveuo(erraac, 'L', jeeact)
    call jeveuo(erreni, 'L', jeeniv)
!
! --- AU MOINS UN EVENEMENT DE CE NIVEAU D'ERREUR EST ACTIVE ?
!
    do 15 ieven = 1, zeven
        icode = zi(jeeact-1+ieven)
        teven = zk16(jeeniv-1+ieven)(1:9)
        if (teven(1:4) .eq. typevt) then
            if (typevt .eq. 'EVEN') then
                if (icode .eq. 1) levent = .true.
            else
                if (teven(6:9) .eq. nombcl) then
                    if (icode .eq. 1) levent = .true.
                endif
            endif
        endif
 15 end do
!
    call jedema()
end subroutine
