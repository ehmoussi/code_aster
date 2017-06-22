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

subroutine chckco(char, noma, ndimg)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfcald.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfnumm.h"
#include "asterfort/cfnumn.h"
#include "asterfort/cfposn.h"
#include "asterfort/cftypm.h"
#include "asterfort/cftypn.h"
#include "asterfort/cfzonn.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/mminfi.h"
#include "asterfort/mmtypm.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8) :: char, noma
    integer :: ndimg
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - LECTURE DONNEES)
!
! VERIFICATION DES TANGENTES/NORMALES
!
! ----------------------------------------------------------------------
!
!
! IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
! IN  NOMA   : NOM DU MAILLAGE
! IN  NDIMG  : NOMBRE DE DIMENSIONS DU PROBLEME
!
!
!
!
    character(len=24) :: defico
    integer :: ino, posno, izone
    integer :: ima, posma, numma
    integer :: ndim, nnoma
    integer :: posnno(9), numnno(9)
    character(len=4) :: typno, typma
    character(len=8) :: alias, nomma
    aster_logical :: lpoutr, lpoint
    integer :: itype
    integer :: nmaco
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    defico = char(1:8)//'.CONTACT'
    nmaco = cfdisi(defico,'NMACO')
!
! --- BOUCLE SUR LES MAILLES
!
    do ima = 1, nmaco
        posma = ima
!
! ----- NUMERO ABSOLU DE LA MAILLE
!
        call cfnumm(defico, posma, numma)
        call jenuno(jexnum(noma//'.NOMMAI', numma ), nomma)
!
! ----- TYPE DE LA MAILLE
!
        call cftypm(defico, posma, typma)
!
! ----- INDICES DANS CONTNO DES NOEUDS DE LA MAILLE
!
        call cfposn(defico, posma, posnno, nnoma)
!
! ----- INDICES ABSOLUS DANS LE MAILLAGE DES NOEUDS DE LA MAILLE
!
        call cfnumn(defico, nnoma, posnno, numnno)
!
! ----- TYPE DE LA MAILLE
!
        call mmtypm(noma, numma, nnoma, alias, ndim)
!
! ----- TYPE DE MAILLE
!
        lpoutr = (alias(1:2).eq.'SE').and.(ndimg.eq.3)
        lpoint = alias.eq.'PO1'
!
! ----- BOUCLE SUR LES NOEUDS DE LA MAILLE
!
        do ino = 1, nnoma
            posno = posnno(ino)
!
! ------- ZONE DU NOEUD
!
            call cfzonn(defico, posno, izone)
!
! ------- TYPE DU NOEUD
!
            call cftypn(defico, posno, typno)
            if (.not.cfcald(defico,izone ,typno )) then
                goto 16
            endif
!
! ------- CHOIX DE LA NORMALE SUIVANT UTILISATEUR
!
            if (typno .eq. 'ESCL') then
                itype = mminfi(defico,'VECT_ESCL',izone)
            else if (typno.eq.'MAIT') then
                itype = mminfi(defico,'VECT_MAIT',izone)
            else
                ASSERT(.false.)
            endif
!
! ------- CALCUL DES TANGENTES EN CE NOEUD SI ELEMENT POINT
!
            if (lpoint) then
!
! --------- MAILLE POI1 SEULEMENT ESCLAVE
!
                if (typma .eq. 'MAIT') then
                    call utmess('F', 'CONTACT3_75', sk=nomma)
                endif
!
! -------- CHOIX DE LA NORMALE SUIVANT UTILISATEUR
!
                if ((itype.eq.0) .or. (itype.eq.2)) then
                    call utmess('F', 'CONTACT3_60', sk=nomma)
                endif
                goto 15
            endif
!
! ------- CALCUL DES TANGENTES EN CE NOEUD SI ELEMENT POUTRE
!
            if (lpoutr) then
                if (itype .eq. 0) then
                    call utmess('F', 'CONTACT3_61', sk=nomma)
                endif
                goto 15
            endif
!
 16         continue
!
        end do
 15     continue
    end do
!
    call jedema()
end subroutine
