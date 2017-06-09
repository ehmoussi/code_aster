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

subroutine majour(neq, lgrot, lendo, sdnume, chaini,&
                  chadel, coef, chamaj, ordre)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmgrot.h"
    character(len=19) :: sdnume
    aster_logical :: lgrot, lendo
    integer :: neq, ordre
    real(kind=8) :: chaini(*), chadel(*), chamaj(*), coef
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - UTILITAIRE - STATIQUE)
!
! MET A JOUR LES CHAM_NO DES DEPLACEMENTS
!
! ----------------------------------------------------------------------
!
!
! CHAMAJ = CHAINI + COEF*CHADEL.
!   POUR LES TRANSLATIONS ET LES PETITES ROTATIONS, ON APPLIQUE
!   LA FORMULE PRECEDENTE A LA LETTRE.
!   POUR LES GRANDES ROTATIONS, LE VECTEUR-ROTATION DE CHAMAJ
!   EST CELUI DU PRODUIT DE LA ROTATION DEFINIE DANS CHAINI PAR
!   COEF FOIS L'INCREMENT DE ROTATION DEFINI DANS CHADEL.
!
! IN  NEQ    : LONGUEUR DES CHAM_NO
! IN  SDNUME : SD NUMEROTATION
! IN  LGROT  : TRUE  S'IL Y A DES DDL DE GRDE ROTATION
!                       FALSE SINON
! IN  CHAINI : CHAM_NO DONNE
! IN  CHADEL : CHAM_NO DONNE
! IN  COEF   : REEL DONNE
! IN  ORDRE  : 0 -> MAJ INCREMENTS
!              1 -> MAJ DEPL
! OUT CHAMAJ : CHAM_NO MIS A JOUR
!
!
!
!
    integer :: iran(3), i, icomp, endo
    real(kind=8) :: theta(3), deldet(3)
    integer :: ptdo, indic1, indic2
    real(kind=8) :: stok
    real(kind=8) :: zero
    integer, pointer :: ndro(:) => null()
    parameter   (zero = 0.0d+0)
!
! ----------------------------------------------------------------------
!
    ptdo = 0
    indic1 = 0
    indic2 = 0
!
    call jemarq()
!
    if (lgrot) then
        call jeveuo(sdnume//'.NDRO', 'L', vi=ndro)
    endif
!
    if (lendo) then
        call jeveuo(sdnume(1:19)//'.ENDO', 'E', endo)
    endif
!
    if (.not.lgrot .and. lendo) then
        do 10 i = 1, neq
            stok = chaini(i)
            chamaj(i) = chaini(i) + coef*chadel(i)
            if (zi(endo+i-1) .ne. 0) then
!
!           ON IMPOSE L'ACCROISSEMENT DE L'ENDO
!
                if (ordre .eq. 0) then
                    if (chamaj(i) .le. zero) then
                        indic1 = indic1+1
                        chamaj(i) = 0.d0
                        chadel(i) = - stok/coef
                        zi(endo+i-1)=2
                    else
                        zi(endo+i-1)=1
                        ptdo = ptdo+1
                    endif
                endif
!
!           ON IMPOSE L'ENDO <= 1
!
                if (ordre .eq. 1) then
                    if (chamaj(i) .ge. 1.d0) then
                        indic2 = indic2+1
                        chamaj(i) = 1.d0
                        chadel(i) = (1.d0-stok)/coef
                    endif
                endif
!
            endif
!
 10     continue
!
!        IF (ORDRE.EQ.0) THEN
!          WRITE(6,*) 'NB_NO_ENDO=', PTDO
!          WRITE(6,*) 'INDIC1=', INDIC1
!          WRITE(6,*) 'INDIC2=', INDIC2
!        ENDIF
!
    else if (.not.lgrot) then
        do 20 i = 1, neq
            chamaj(i) = chaini(i) + coef*chadel(i)
 20     continue
    else
        icomp = 0
        do 30 i = 1, neq
            if (ndro(i) .eq. 0) then
                chamaj(i) = chaini(i) + coef*chadel(i)
            else if (ndro(i).eq.1) then
                icomp = icomp + 1
                iran(icomp) = i
                theta(icomp) = chaini(i)
                deldet(icomp) = coef*chadel(i)
                if (icomp .eq. 3) then
                    icomp = 0
                    call nmgrot(iran, deldet, theta, chamaj)
                endif
            else
                ASSERT(.false.)
            endif
 30     continue
    endif
!
    call jedema()
end subroutine
