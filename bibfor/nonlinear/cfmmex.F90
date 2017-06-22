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

subroutine cfmmex(defico, typexc, izone, numnoe, suppok)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: defico
    character(len=4) :: typexc
    integer :: izone
    integer :: numnoe
    integer :: suppok
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
!
! DIT SI LE NOEUD FAIT PARTIE D'UNE LISTE DONNE PAR L'UTILISATEUR
!   SANS_GROUP_NO/SANS_NOEUD
!   SANS_GROUP_NO_FR/SANS_NOEUD_FR
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
! IN  TYPEXC : TYPE D'EXCLUSION
!               'FROT' DONNE PAR SANS_*_FR
!               'CONT' DONNE PAR SANS_*
! IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
! IN  NUMNOE : NUMERO ABSOLUE DU NOEUD A CHERCHER
! OUT SUPPOK : VAUT 1 SI LE NOEUD FAIT PARTIE DES NOEUDS EXCLUS
!
!
!
!
    character(len=24) :: sansno, psans, frotno, pfrot
    integer :: jsanc, jpsanc, jsanf, jpsanf
    integer :: jsans, jpsans
    integer :: nsans, numsan, k
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES OBJETS
!
    sansno = defico(1:16)//'.SSNOCO'
    psans = defico(1:16)//'.PSSNOCO'
    frotno = defico(1:16)//'.SANOFR'
    pfrot = defico(1:16)//'.PSANOFR'
!
! --- INITIALISATIONS
!
    suppok = 0
    if (typexc .eq. 'CONT') then
        call jeveuo(sansno, 'L', jsanc)
        call jeveuo(psans, 'L', jpsanc)
        jsans = jsanc
        jpsans = jpsanc
    else if (typexc.eq.'FROT') then
        call jeveuo(frotno, 'L', jsanf)
        call jeveuo(pfrot, 'L', jpsanf)
        jsans = jsanf
        jpsans = jpsanf
    else
        ASSERT(.false.)
    endif
    nsans = zi(jpsans+izone) - zi(jpsans+izone-1)
!
! --- REPERAGE SI LE NOEUD EST UN NOEUD DE LA LISTE
!
    do 30 k = 1, nsans
        numsan = zi(jsans+zi(jpsans+izone-1)+k-1)
        if (numnoe .eq. numsan) then
            suppok = 1
            goto 40
        endif
30  end do
40  continue
!
    call jedema()
end subroutine
