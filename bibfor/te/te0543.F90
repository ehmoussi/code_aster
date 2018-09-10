! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
subroutine te0543(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lcegeo.h"
#include "asterfort/lteatt.h"
#include "asterfort/pipeed.h"
#include "asterfort/pipepe.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES COEFFICIENTS A0 ET A1
!                          POUR LE PILOTAGE PAR CRITERE ELASTIQUE
!                          OU PAR INCREMENT DE DEFORMATION POUR LES
!                          ELEMENTS A VARIABLES LOCALES
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    character(len=8) :: typmod(2)
    character(len=16) :: compor, pilo
!
    integer :: jgano, ndim, nno, nnos, npg, lgpg, jtab(7), itype
    integer :: ipoids, ivf, idfde, igeom, imate, jvariexte, icarcr
    integer :: icontm, ivarim, icopil, iborne, ictau
    integer :: ideplm, iddepl, idepl0, idepl1, icompo, iret
!
! - TYPE DE MODELISATION
!
    if (lteatt('DIM_TOPO_MODELI','3')) then
        typmod(1) = '3D'
    else if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS'
    else if (lteatt('C_PLAN','OUI')) then
        typmod(1) = 'C_PLAN'
    else if (lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN'
    endif
!
    typmod(2) = 'DEPLA'
!
    if (lteatt('TYPMOD2','ELEMDISC')) then
        typmod(2)='ELEMDISC'
    endif
!
! - FONCTIONS DE FORMES ET POINTS DE GAUSS
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    ASSERT(nno .le. 27)
    ASSERT(npg .le. 27)
!
! - PARAMETRES EN ENTREE
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDDEPLR', 'L', iddepl)
    call jevech('PDEPL0R', 'L', idepl0)
    call jevech('PDEPL1R', 'L', idepl1)
    call jevech('PTYPEPI', 'L', itype)
    call jevech('PCARCRI', 'L', icarcr)
!
    pilo = zk16(itype)
    compor = zk16(icompo)
    if (pilo .eq. 'PRED_ELAS') then
        call jevech('PCDTAU', 'L', ictau)
        call jevech('PBORNPI', 'L', iborne)
    endif
!
!
! -- NOMBRE DE VARIABLES INTERNES
!
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,&
                itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! - Compute intrinsic external state variables
!
    if (compor .eq. 'BETON_DOUBLE_DP') then
        jvariexte = nint(zr(icarcr-1+IVARIEXTE))
        call lcegeo(nno      , npg      , ndim ,&
                    ipoids   , ivf      , idfde,&
                    typmod   , jvariexte,&
                    zr(igeom),&
                    zr(ideplm), zr(iddepl))
    endif
!
! PARAMETRES EN SORTIE
!
    call jevech('PCOPILO', 'E', icopil)
!
    if (typmod(2) .eq. 'ELEMDISC') then
        call pipeed(nno, npg, ipoids, ivf, idfde,&
                    zr(igeom), typmod, zi(imate), lgpg, zr(ideplm),&
                    zr(ivarim), zr(iddepl), zr(idepl0), zr(idepl1),&
                    zr(ictau), zr(icopil))
    else
        call pipepe(pilo, ndim, nno, npg, ipoids,&
                    ivf, idfde, zr( igeom), typmod, zi(imate),&
                    zk16(icompo), lgpg, zr(ideplm), zr( icontm), zr(ivarim),&
                    zr(iddepl), zr(idepl0), zr(idepl1), zr( icopil),&
                    iborne, ictau)
    endif
!
end subroutine
