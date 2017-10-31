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

subroutine te0545(option, nomte)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefv.h"
#include "asterfort/jevech.h"
#include "asterfort/ngfint.h"
#include "asterfort/ngvlog.h"
#include "asterfort/nglgic.h"
#include "asterfort/nmgvmb.h"
#include "asterfort/nmtstm.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcangm.h"
#include "asterfort/teattr.h"
#include "asterfort/lteatt.h"
#include "asterfort/tecach.h"
#include "blas/dcopy.h"
#include "blas/dgemv.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
!                          EN 2D (CPLAN ET DPLAN) ET AXI
!                          POUR LES ELEMNTS GRAD_VARI
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
    character(len=8) :: typmod(2)
    aster_logical :: resi, rigi, axi,matsym
    integer :: nno, nnob, npg, ndim, nddl, neps, lgpg
    integer :: ipoids, ivf, idfde, ivfb, idfdeb
    integer :: imate, icontm, ivarim, iinstm, iinstp, ideplm, ideplp, icompo
    integer :: ivectu, icontp, ivarip, imatuu, icarcr, ivarix, igeom, icoret
    integer :: iret, nnos, jgano, jganob, jtab(7)
    integer :: i
    real(kind=8) :: xyz(3)=0.d0, angmas(7)
    real(kind=8),allocatable:: b(:,:,:), w(:,:),ni2ldc(:,:)
!

! - INITIALISATION
!
    resi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RAPH_MECA'
    rigi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RIGI_MECA'
    call teattr('S', 'TYPMOD', typmod(1), iret)
    typmod(2) = 'GRADVARI'
    axi = typmod(1).eq.'AXIS'


    call elrefv(nomte, 'RIGI', ndim, nno, nnob,&
                nnos, npg, ipoids, ivf, ivfb,&
                idfde, idfdeb, jgano, jganob)
!
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
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
!
!
! - PARAMETRES EN SORTIE
!

    if (rigi) then
        call nmtstm(zr(icarcr), imatuu, matsym)
    else
        imatuu = 1
    endif

!
    if (resi) then
        call jevech('PVECTUR', 'E', ivectu)
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PCODRET', 'E', icoret)
    else
        ivectu=1
        icontp=1
        ivarip=1
        icoret=1
    endif
!
!
!    NOMBRE DE VARIABLES INTERNES
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,&
                itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
!
!    ESTIMATION VARIABLES INTERNES A L'ITERATION PRECEDENTE
    if (resi) then
        call jevech('PVARIMP', 'L', ivarix)
        zr(ivarip:ivarip-1+npg*lgpg) = zr(ivarix:ivarix-1+npg*lgpg)
    endif
!
!
!    BARYCENTRE ET ORIENTATION DU MASSIF
    do i = 1,ndim
        xyz(ndim) = sum(zr(igeom-1+i:igeom-1+(nno-1)*ndim+i:ndim))/nno
    end do
    call rcangm(ndim, xyz, angmas)
!
!
!
! - CALCUL DES FORCES INTERIEURES ET MATRICES TANGENTES
!
     if (zk16(icompo+2) (1:8).eq.'GDEF_LOG') then
        if (lteatt('INCO','C5GV')) then
            nddl = nno*ndim+4*nnob
            call nglgic('RIGI', option, typmod, ndim, nno,nnob,&
                       npg,nddl, ipoids, zr(ivf), zr(ivfb),idfde,idfdeb,&
                       zr(igeom),zk16(icompo), zi(imate), lgpg,&
                       zr(icarcr), angmas, zr(iinstm), zr(iinstp), matsym,&
                       zr( ideplm), zr(ideplp), zr(icontm), zr(ivarim), zr(icontp),&
                       zr( ivarip), zr(ivectu), zr(imatuu), zi(icoret))




        else
            nddl = nno*ndim+2*nnob
            neps = 3*ndim +2
            call ngvlog('RIGI', option, typmod, ndim, nno,nnob,neps,&
                   npg,nddl, ipoids, zr(ivf), zr(ivfb),idfde,idfdeb,&
                   zr(igeom),zk16(icompo), zi(imate), lgpg,&
                   zr(icarcr), angmas, zr(iinstm), zr(iinstp), matsym,&
                   zr( ideplm), zr(ideplp), zr(icontm), zr(ivarim), zr(icontp),&
                   zr( ivarip), zr(ivectu), zr(imatuu), zi(icoret))


        endif



     else if (zk16(icompo+2) (1:5) .eq. 'PETIT') then
        call nmgvmb(ndim, nno, nnob, npg, axi,.false._1,&
                    zr(igeom), zr(ivf), zr(ivfb), idfde, idfdeb,&
                    ipoids, nddl, neps, b, w,&
                    ni2ldc)
                    
        call ngfint(option, typmod, ndim, nddl, neps,&
                    npg, w, b, zk16(icompo), 'RIGI',&
                    zi(imate), angmas, lgpg, zr(icarcr), zr(iinstm),&
                    zr(iinstp), zr(ideplm), zr(ideplp), ni2ldc, zr(icontm),&
                    zr(ivarim), zr(icontp), zr(ivarip), zr(ivectu), zr(imatuu),&
                    zi(icoret))

        deallocate(b,w,ni2ldc)
     endif
!
end subroutine
