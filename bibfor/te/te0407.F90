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

subroutine te0407(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/nmas3d.h"
#include "asterfort/rcangm.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "blas/dcopy.h"
!
! aslint: disable=W0104
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
!                          ELEMENT HEXAS8
!          => 1 POINT DE GAUSS + STABILISATION ASSUMED STRAIN
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
    character(len=8) :: typmod(2)
    character(len=16) :: mult_comp
    integer :: jgano, nno, npg, i, imatuu, lgpg, ndim, lgpg1, iret
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: icontm, ivarim
    integer :: iinstm, iinstp, ideplm, ideplp, icompo, icarcr
    integer :: ivectu, icontp, ivarip, jcret, codret
    integer :: ivarix, jv_mult_comp
    integer :: jtab(7), nnos, idim
    real(kind=8) :: def(6, 3, 8), dfdi(8, 3)
    real(kind=8) :: angmas(7), bary(3)
!
    icontp=1
    ivarip=1
    imatuu=1
    ivectu=1
!
! - FONCTIONS DE FORMES ET POINTS DE GAUSS
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
! - TYPE DE MODELISATION
    typmod(1) = '3D      '
    typmod(2) = '        '
!
! - PARAMETRES EN ENTREE
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PDEPLPR', 'L', ideplp)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PCARCRI', 'L', icarcr)
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,&
                itab=jtab)
    lgpg1 = max(jtab(6),1)*jtab(7)
    lgpg = lgpg1
    bary(1) = 0.d0
    bary(2) = 0.d0
    bary(3) = 0.d0
    call jevech('PMULCOM', 'L', jv_mult_comp)
    mult_comp = zk16(jv_mult_comp-1+1)
    do i = 1, nno
        do idim = 1, ndim
            bary(idim) = bary(idim)+zr(igeom+idim+ndim*(i-1)-1)/nno
        end do
    end do
    call rcangm(ndim, bary, angmas)
!
! - VARIABLES DE COMMANDE
!
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
!
! - PARAMETRES EN SORTIE
!
    if (option(1:10) .eq. 'RIGI_MECA_' .or. option(1:9) .eq. 'FULL_MECA') then
        call jevech('PMATUUR', 'E', imatuu)
    endif
!
!
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call jevech('PVECTUR', 'E', ivectu)
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVARIPR', 'E', ivarip)
!
!      ESTIMATION VARIABLES INTERNES A L'ITERATION PRECEDENTE
        call jevech('PVARIMP', 'L', ivarix)
        call dcopy(npg*lgpg, zr(ivarix), 1, zr(ivarip), 1)
!
    endif
!
!
    if (zk16(icompo+3) (1:9) .eq. 'COMP_ELAS') then
!
! - LOIS DE COMPORTEMENT ECRITES EN CONFIGURATION DE REFERENCE
!                          COMP_ELAS
!
        call utmess('F', 'ELEMENTS4_73')
    else
!
! - LOIS DE COMPORTEMENT ECRITE EN CONFIGURATION ACTUELLE
!                          COMP_INCR
!      PETITES DEFORMATIONS (AVEC EVENTUELLEMENT REACTUALISATION)
        if (zk16(icompo+2) (1:5) .eq. 'PETIT') then
            if (zk16(icompo+2) (6:10) .eq. '_REAC') then
                do i = 1, 3*nno
                    zr(igeom+i-1) = zr(igeom+i-1) + zr(ideplm+i-1) + zr(ideplp+i-1)
                end do
            endif
            call nmas3d('RIGI', nno, npg, ipoids, ivf,&
                        idfde, zr(igeom), typmod, option, zi(imate),&
                        zk16(icompo), mult_comp, lgpg, zr(icarcr), zr(iinstm), zr(iinstp),&
                        zr(ideplm), zr(ideplp), angmas, zr(icontm), zr(ivarim),&
                        dfdi, def, zr(icontp), zr(ivarip), zr(imatuu),&
                        zr(ivectu), codret)
        else
            call utmess('F', 'ELEMENTS3_16', sk=zk16(icompo+2))
        endif
    endif
!
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call jevech('PCODRET', 'E', jcret)
        zi(jcret) = codret
    endif
!
end subroutine
