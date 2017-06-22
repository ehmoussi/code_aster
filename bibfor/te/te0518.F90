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

subroutine te0518(option, nomte)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefv.h"
#include "asterfort/jevech.h"
#include "asterfort/ngpipe.h"
#include "asterfort/nmgvmb.h"
#include "asterfort/teattr.h"
#include "asterfort/tecach.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!   CALCUL DES COEFFICIENTS A0 ET A1 POUR LE PILOTAGE PAR CRITERE
!   ELASTIQUE OU PAR DEFORMATION POUR LES ELEMENTS GRAD_VARI
! ......................................................................
    integer :: nnomax, npgmax, epsmax, ddlmax
    parameter (nnomax=27,npgmax=27,epsmax=20,ddlmax=15*nnomax)
! ......................................................................
    character(len=8) :: typmod(2)
    character(len=16) :: typilo
    aster_logical :: axi
    integer :: nno, nnob, npg, ndim, nddl, neps, lgpg, jtab(7)
    integer :: iret, nnos, jgano, ipoids, ivf, idfde, ivfb, idfdeb, jganob
    integer :: igeom, imate, itype, icontm, ivarim, icopil, iborne, ictau
    integer :: iddlm, iddld, iddl0, iddl1, icompo
    real(kind=8) :: b(epsmax, npgmax, ddlmax), w(npgmax), ni2ldc(epsmax)
    real(kind=8) :: etamin, etamax
    character(len=16) :: nomelt
    common /ffauto/ nomelt
!
!
! - INITIALISATION
!
    nomelt = nomte
    call teattr('S', 'TYPMOD', typmod(1), iret)
    typmod(2) = 'GRADVARI'
    axi = typmod(1).eq.'AXIS'
!
    call elrefv(nomte, 'RIGI', ndim, nno, nnob,&
                nnos, npg, ipoids, ivf, ivfb,&
                idfde, idfdeb, jgano, jganob)
!
!
! - CALCUL DES ELEMENTS CINEMATIQUES
!
    call jevech('PGEOMER', 'L', igeom)
    call nmgvmb(ndim, nno, nnob, npg, axi,&
                zr(igeom), zr(ivf), zr(ivfb), idfde, idfdeb,&
                ipoids, nddl, neps, b, w,&
                ni2ldc)
! - TYPE DE PILOTAGE (IDENTIQUE A UNE SELECTION VIA LE NOM DE L'OPTION
!
    call jevech('PTYPEPI', 'L', itype)
    typilo = zk16(itype)
!
!
! - PARAMETRES COMMUNS AUX MODELES DE PILOTAGE
!
    call jevech('PDEPLMR', 'L', iddlm)
    call jevech('PDDEPLR', 'L', iddld)
    call jevech('PDEPL0R', 'L', iddl0)
    call jevech('PDEPL1R', 'L', iddl1)
    call jevech('PCDTAU', 'L', ictau)
    call jevech('PCOPILO', 'E', icopil)
!
!
! - PARAMETRES SPECIFIQUES AU PILOTAGE PAR LA LOI DE COMPORTEMENT
!
    if (typilo .eq. 'PRED_ELAS') then
        call jevech('PMATERC', 'L', imate)
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PBORNPI', 'L', iborne)
!
!      BORNES POUR LE PILOTAGE (SELON LOIS DE COMPORTEMENT)
        etamin=zr(iborne+1)
        etamax=zr(iborne)
!
!      NOMBRE DE VARIABLES INTERNES
        call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,&
                    itab=jtab)
        lgpg = max(jtab(6),1)*jtab(7)
    else
        imate=1
        icompo=1
        icontm=1
        ivarim=1
        iborne=1
        lgpg=0
        etamin=0.d0
        etamax=0.d0
    endif
!
    call ngpipe(typilo, npg, neps, nddl, b,&
                ni2ldc, typmod, zi(imate), zk16(icompo), lgpg,&
                zr(iddlm), zr(icontm), zr(ivarim), zr(iddld), zr(iddl0),&
                zr(iddl1), zr(ictau), etamin, etamax, zr(icopil))
!
end subroutine
