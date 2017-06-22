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

subroutine nmpidd(numedd, sdpilo, dtau, depdel, ddepl0,&
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
    integer :: nbeffe
    integer :: pilcvg
    real(kind=8) :: eta, dtau
    character(len=19) :: sdpilo
    character(len=19) :: ddepl0, ddepl1, depdel
    character(len=24) :: numedd
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PILOTAGE - CALCUL DE ETA)
!
! RESOLUTION DE L'EQUATION DE PILOTAGE PAR UN DDL IMPOSE
!
! ----------------------------------------------------------------------
!
!
! IN  SDPILO : SD PILOTAGE
! IN  NUMEDD : NUME_DDL
! IN  DTAU   : SECOND MEMBRE DE L'EQUATION DE PILOTAGE
! IN  DEPDEL : INCREMENT DE DEPLACEMENT DEPUIS DEBUT PAS DE TEMPS
! IN  DDEPL0 : INCREMENT DE DEPLACEMENT K-1.F_DONNE
! IN  DDEPL1 : INCREMENT DE DEPLACEMENT K-1.F_PILO
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
    real(kind=8) :: du, rn, rd
    integer :: neq
    character(len=19) :: chapil
    integer :: ifm, niv
    real(kind=8), pointer :: coef(:) => null()
    real(kind=8), pointer :: dep0(:) => null()
    real(kind=8), pointer :: dep1(:) => null()
    real(kind=8), pointer :: depde(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('PILOTAGE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<PILOTAGE> ...... PILOTAGE PAR DDL IMPOSE'
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
    call jeveuo(depdel(1:19)//'.VALE', 'L', vr=depde)
    chapil = sdpilo(1:14)//'.PLCR'
    call jeveuo(chapil(1:19)//'.VALE', 'L', vr=coef)
!
! --- RESOLUTION DE L'EQUATION
!
    rn = ddot(neq,dep0,1,coef,1)
    rd = ddot(neq,dep1,1,coef,1)
    du = ddot(neq,depde,1,coef,1)
    if (rd .eq. 0.d0) then
        pilcvg = 1
    else
        eta = (dtau - du - rn) / rd
        nbeffe = 1
        pilcvg = 0
    endif
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<PILOTAGE> ...... (RN,RD,DU) : ',rn,rd,du
    endif
!
    call jedema()
!
end subroutine
