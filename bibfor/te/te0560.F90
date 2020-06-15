! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine te0560(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/elrefv.h"
#include "asterfort/jevech.h"
#include "asterfort/massup.h"
#include "asterfort/nmgvno.h"
#include "asterfort/nmtstm.h"
#include "asterfort/rcangm.h"
#include "asterfort/teattr.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "blas/dcopy.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_GVNO
!           D_PLAN_GVNO
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!          MASS_MECA*
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: matsym
    integer :: nb_DOF
    integer :: nnoQ, npg, i, imatuu, lgpg, lgpg1, ndim
    integer :: jv_poids, jv_vfQ, jv_dfdeQ, igeom, imate
    integer :: nnoL, jv_vfL, jv_dfdeL, jv_ganoL
    integer :: icontm, ivarim
    integer :: iinstm, iinstp, ideplm, ideplp, icompo, icarcr
    integer :: ivectu, icontp, ivarip, nnos, jv_ganoQ
    integer :: ivarix, idim, iret
    integer :: jtab(7), jcret, codret
    real(kind=8) :: xyz(3)
    real(kind=8) :: angmas(7)
    integer :: icodr1(1)
    character(len=8) :: typmod(2)
    character(len=4) :: fami
    character(len=16) :: elasKeyword, defo_comp
    aster_logical :: lVect, lMatr, lVari, lSigm
!
! --------------------------------------------------------------------------------------------------
!
    codret = 0
!
! - Type of modelling
!
    call teattr('S', 'TYPMOD' , typmod(1))
    call teattr('S', 'TYPMOD2', typmod(2))
!
! - Get parameters of element
!
    fami = 'RIGI'
    if (option .eq. 'MASS_MECA') then
        fami = 'MASS'
    endif
    call elrefv(fami    , ndim    ,&
                nnoL    , nnoQ    , nnos,&
                npg     , jv_poids,&
                jv_vfL  , jv_vfQ  ,&
                jv_dfdeL, jv_dfdeQ,&
                jv_ganoL, jv_ganoQ)
    ASSERT(ndim.eq.2 .or. ndim.eq.3)
!
! - Input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
!
    if (option(1:9) .eq. 'MASS_MECA') then
! ---------------- CALCUL MATRICE DE MASSE ------------------------
!
        call jevech('PMATUUR', 'E', imatuu)
! ----- nb_DOF: displacements (2 or 3) + VARI
        nb_DOF = ndim + 2
!
        call massup(option, ndim, nb_DOF, nnoQ, nnoL,&
                    zi(imate), elasKeyword, npg, jv_poids, jv_dfdeQ,&
                    zr(igeom), zr(jv_vfQ), imatuu, icodr1, igeom,&
                    jv_vfQ)
!
! --------------- FIN CALCUL MATRICE DE MASSE -----------------------
    else
!
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCARCRI', 'L', icarcr)
! ----- Behaviour
        defo_comp = zk16(icompo-1+DEFO)
        if (defo_comp .ne. 'PETIT') then
            call utmess('F', 'ELEMENTS3_16', sk=defo_comp)
        endif
! ----- Select objects to construct from option name
        call behaviourOption(option, zk16(icompo),&
                             lMatr , lVect ,&
                             lVari , lSigm)
!
        call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
        lgpg1 = max(jtab(6),1)*jtab(7)
        lgpg = lgpg1
!
!     ORIENTATION DU MASSIF
!     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )
!
        xyz = 0.d0
!
        do i = 1, nnoQ
            do idim = 1, ndim
                xyz(idim) = xyz(idim)+zr(igeom+idim+ndim*(i-1)-1)/nnoQ
            end do
        end do
        call rcangm(ndim, xyz, angmas)
!
!     VARIABLES DE COMMANDE
!
        call jevech('PINSTMR', 'L', iinstm)
        call jevech('PINSTPR', 'L', iinstp)
!
!     PARAMETRES EN SORTIE
!
        ivectu=1
        icontp=1
        ivarip=1
        if (lMatr) then
            call nmtstm(zr(icarcr), imatuu, matsym)
        endif
        if (lVect) then
            call jevech('PVECTUR', 'E', ivectu)
        endif
        if (lSigm) then
            call jevech('PCODRET', 'E', jcret)

            call jevech('PCONTPR', 'E', icontp)
        endif
        if (lVari) then
            call jevech('PVARIPR', 'E', ivarip)
            call jevech('PVARIMP', 'L', ivarix)
            call dcopy(npg*lgpg, zr(ivarix), 1, zr(ivarip), 1)
        endif
!
        if (option .eq. 'RIGI_MECA_ELAS' .or. option .eq. 'FULL_MECA_ELAS' .or.&
            option .eq. 'RAPH_MECA') then
            fami = 'ELAS'
        else
            fami = 'RIGI'
        endif
!
        call nmgvno(fami, ndim, nnoQ, nnoL, npg,&
                    jv_poids, zr(jv_vfQ), zr(jv_vfL), jv_dfdeQ, jv_dfdeL,&
                    zr(igeom), typmod, option, zi(imate), zk16(icompo),&
                    lgpg, zr(icarcr), zr(iinstm), zr(iinstp), zr(ideplm),&
                    zr(ideplp), angmas, zr(icontm), zr(ivarim), zr(icontp),&
                    zr(ivarip), zr(imatuu), zr(ivectu), codret)
!
    endif
!
    if (lSigm) then
        zi(jcret) = codret
    endif
!
end subroutine
