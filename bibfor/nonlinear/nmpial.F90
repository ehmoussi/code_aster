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

subroutine nmpial(numedd, depdel, depmoi, cnfepi, ddepl0,&
                  ddepl1, eta, pilcvg, nbeffe)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "blas/ddot.h"
    integer :: nbeffe, pilcvg
    real(kind=8) :: eta
    character(len=19) :: ddepl0, ddepl1, depdel, cnfepi
    character(len=19) :: depmoi
    character(len=24) :: numedd
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE - CALCUL DE ETA)
!
! RESOLUTION DE L'EQUATION DE PILOTAGE POUR ANALYSE LIMITE
!
! ----------------------------------------------------------------------
!
!
! IN  NUMEDD : NUME_DDL
! IN  DEPMOI : DEPLACEMENT AU DEBUT DU PAS DE TEMPS
! IN  DEPDEL : INCREMENT DE DEPLACEMENT DEPUIS DEBUT PAS DE TEMPS
! IN  DDEPL0 : INCREMENT DE DEPLACEMENT K-1.F_DONNE
! IN  DDEPL1 : INCREMENT DE DEPLACEMENT K-1.F_PILO
! IN  CNFEPI : VECT_ASSE FORCES PILOTEES
! OUT NBEFFE : NOMBRE DE SOLUTIONS EFFECTIVES
! OUT ETA    : ETA_PILOTAGE
! OUT PILCVG : CODE DE CONVERGENCE POUR LE PILOTAGE
!                -1 : PAS DE CALCUL DU PILOTAGE
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : PAS DE SOLUTION
!                 2 : BORNE ATTEINTE -> FIN DU CALCUL
!
!
!
!
    real(kind=8) :: du, rn, rd, um
    integer :: neq
    integer :: ifm, niv
    real(kind=8), pointer :: dep0(:) => null()
    real(kind=8), pointer :: dep1(:) => null()
    real(kind=8), pointer :: depde(:) => null()
    real(kind=8), pointer :: depm(:) => null()
    real(kind=8), pointer :: line(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('PILOTAGE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<PILOTAGE> ...... PILOTAGE PAR TRAVAIL UNITAIRE'
    endif
!
! --- INITIALISATIONS
!
    pilcvg = -1
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
!
! --- ACCES OBJETS JEVEUX
!
    call jeveuo(ddepl0(1:19)//'.VALE', 'L', vr=dep0)
    call jeveuo(ddepl1(1:19)//'.VALE', 'L', vr=dep1)
    call jeveuo(depmoi(1:19)//'.VALE', 'L', vr=depm)
    call jeveuo(depdel(1:19)//'.VALE', 'L', vr=depde)
    call jeveuo(cnfepi(1:19)//'.VALE', 'L', vr=line)
!
! --- RESOLUTION DE L'EQUATION
!
    um = ddot(neq,depm,1,line,1)
    du = ddot(neq,depde,1,line,1)
    rn = ddot(neq,dep0,1,line,1)
    rd = ddot(neq,dep1,1,line,1)
    if (rd .eq. 0.d0) then
        pilcvg = 1
    else
        eta = (1.d0 - um - du - rn) / rd
        nbeffe = 1
        pilcvg = 0
    endif
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<PILOTAGE> ...... (RN,RD,DU,UM) : ',rn,rd,du,&
        um
    endif
!
    call jedema()
!
end subroutine
