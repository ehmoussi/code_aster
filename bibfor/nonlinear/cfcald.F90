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

function cfcald(defico, izone, typnoe)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mminfi.h"
#include "asterfort/mminfl.h"
    aster_logical :: cfcald
    character(len=4) :: typnoe
    character(len=24) :: defico
    integer :: izone
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - APPARIEMENT)
!
! DIT SI LA NORMALE DOIT ETRE CALCULEE SUR LE TYPE
! DE NOEUD DONNE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
! IN  IZONE  : ZONE DE CONTACT
! IN  TYPNOE : TYPE DU NOEUD 'MAIT' OU 'ESCL'
! OUT CFCALD : .TRUE. SI NORMALE A CALCULER
!
! ----------------------------------------------------------------------
!
    integer :: iappa
    aster_logical :: lliss, lmait, lescl, lmaes
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    cfcald = .false.
!
! --- FONCTIONNALITES ACTIVEES
!
    lliss = cfdisl(defico,'LISSAGE')
    lmait = mminfl(defico,'MAIT' ,izone)
    lescl = mminfl(defico,'ESCL' ,izone)
    lmaes = mminfl(defico,'MAIT_ESCL' ,izone)
    iappa = mminfi(defico,'APPARIEMENT' ,izone)
!
! --- CALCUL OU NON ?
!
    if (typnoe .eq. 'MAIT') then
        if (lliss) then
            if (lmait .or. lmaes) then
                cfcald = .true.
            endif
        endif
        if (iappa .eq. 0) then
            if (lmait .or. lmaes) then
                cfcald = .true.
            endif
        endif
    else if (typnoe.eq.'ESCL') then
        if (lescl .or. lmaes) then
            cfcald = .true.
        endif
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end function
