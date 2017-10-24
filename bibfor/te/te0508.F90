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

subroutine te0508(option, nomte)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/elrefv.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/ngforc.h"
#include "asterfort/ngfore.h"
#include "asterfort/nmgvmb.h"
#include "asterfort/lgicfc.h"
!#include "asterfort/lgicfr.h"
#include "asterfort/teattr.h"
#include "asterfort/terefe.h"

    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  OPTIONS FORC_NODA ET REFE_FORC_NODA
!                          POUR LA MODELISATION GRAD_VARI
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
    character(len=8) :: typmod
    aster_logical :: axi,grand
    integer :: nno, nnob, npg, ndim, nddl, neps
    integer :: iret, nnos, jgano, ipoids, ivf, idfde, ivfb, idfdeb, jganob
    integer :: igeom, icontm, ivectu, ideplm, icompo
    real(kind=8) :: sigref, varref, lagref,epsref, sref(13)
    real(kind=8),allocatable:: b(:,:,:), w(:,:),ni2ldc(:,:)
    
! ----------------------------------------------------------------------
    
   
! - INITIALISATION

    call teattr('S', 'TYPMOD', typmod, iret)
    axi = typmod.eq.'AXIS'
!
    call elrefv(nomte, 'RIGI', ndim, nno, nnob,&
                nnos, npg, ipoids, ivf, ivfb,&
                idfde, idfdeb, jgano, jganob)
!
!
!
! - Parametres des options
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PVECTUR', 'E', ivectu)
    if (option.eq.'FORC_NODA') then
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PDEPLMR', 'L', ideplm) 
    end if
   

!   GRAD_VARI + GDEF_LOG + INCO

    if (lteatt('INCO','C5GV').and.zk16(icompo+2) (1:8).eq.'GDEF_LOG') then  
         nddl = nno*ndim + nnob*4
         
         if (option .eq. 'FORC_NODA') then
             grand = .true._1 
             call lgicfc(ndim, nno, nnob, npg, nddl, axi,grand,&
                       zr(igeom),zr(ideplm), zr(ivf),zr(ivfb), idfde, idfdeb,&
                       ipoids,zr(icontm),zr(ivectu))
        
        else if (option .eq. 'REFE_FORC_NODA') then
            call terefe('SIGM_REFE', 'MECA_GRADVARI', sigref)
            call terefe('VARI_REFE', 'MECA_GRADVARI', varref)
            call terefe('LAGR_REFE', 'MECA_GRADVARI', lagref)
            call terefe('EPSI_REFE', 'MECA_INCO', epsref)
            if (ndim .eq. 2) then
                sref(1:10) = [sigref,sigref,sigref,sigref,epsref, &
                              sigref,lagref,varref, 0.d0, 0.d0]
            else if (ndim.eq.3) then
                sref(1:13) = [sigref,sigref,sigref,sigref,sigref, &
                              sigref,epsref,sigref,lagref,varref, &
                              0.d0, 0.d0, 0.d0]
            endif
            stop 'not implemented te0508'
            stop 'DEPLM non fourni'
!            call lgicfr(ndim, nno, nnob, npg, nddl, axi,.true._1,&
!                        zr(igeom),zr(ideplm), zr(ivf),zr(ivfb), idfde, idfdeb,&
!                        ipoids,sref,zr(ivectu))
        endif
        goto 9999
    end if
    
    
!   GRAD_VARI + HPP  ET/OU  GRAD_VARI + GDEF_LOG
    if (zk16(icompo+2) (1:5) .eq. 'PETIT' .or. option.eq.'REFE_FORC_NODA') then  ! temporaire
        call nmgvmb(ndim, nno, nnob, npg, axi,.false._1,&
                    zr(igeom), zr(ivf), zr(ivfb), idfde, idfdeb,&
                    ipoids, nddl, neps, b, w,ni2ldc)


!   GRAD_VARI + GDEF_LOG 
    else if (zk16(icompo+2) (1:8).eq.'GDEF_LOG') then
        call nmgvmb(ndim, nno, nnob, npg, axi,.true._1,&
                    zr(igeom), zr(ivf), zr(ivfb), idfde, idfdeb,&
                    ipoids, nddl, neps, b, w,ni2ldc, zr(ideplm))
                    
    else
        ASSERT(.false.)
    end if
! 

    if (option .eq. 'FORC_NODA') then
        call ngforc(w, b, ni2ldc, zr(icontm), zr(ivectu))
!
! - OPTION REFE_FORC_NODA
!
    else if (option .eq. 'REFE_FORC_NODA') then

!      LECTURE DES COMPOSANTES DE REFERENCE
        call terefe('SIGM_REFE', 'MECA_GRADVARI', sigref)
        call terefe('VARI_REFE', 'MECA_GRADVARI', varref)
        call terefe('LAGR_REFE', 'MECA_GRADVARI', lagref)
        
!      AFFECTATION DES CONTRAINTES GENERALISEES DE REFERENCE
        if (ndim .eq. 2) then
            sref(1:neps) = [sigref,sigref,sigref,sigref,lagref, &
                         varref,0.d0,0.d0]
        else if (ndim.eq.3) then
            sref(1:neps) = [sigref,sigref,sigref,sigref,sigref, &
                          sigref,lagref,varref,0.d0,0.d0,0.d0]
        endif
        call ngfore(w,b,ni2ldc,sref,zr(ivectu))
    endif
    deallocate(b,w,ni2ldc)
    
9999 continue
end subroutine
