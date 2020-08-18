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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_pod_incr(lReuse, base, paraPod,&
                        q, s, v, nbMode, nbSnap)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dbr_calcpod_sele.h"
#include "asterfort/dbr_calcpod_svd.h"
#include "asterfort/detrsd.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/norm_frobenius.h"
#include "asterfort/romBaseCreate.h"
#include "asterfort/romTableSave.h"
#include "asterfort/rsexch.h"
#include "asterfort/tbexve.h"
#include "asterfort/tbSuppressAllLines.h"
#include "asterfort/utmess.h"
#include "blas/dgemm.h"
#include "blas/dgesv.h"
!
aster_logical, intent(in) :: lReuse
type(ROM_DS_Empi), intent(inout) :: base
type(ROM_DS_ParaDBR_POD) , intent(in) :: paraPod
real(kind=8), pointer :: q(:), s(:), v(:)
integer, intent(out) :: nbMode, nbSnap
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Incremental POD method
!
! --------------------------------------------------------------------------------------------------
!
! In  lReuse           : .true. if reuse
! IO  base             : base
! In  paraPod          : datastructure for parameters (POD)
! Ptr q                : pointer to snapshots matrix (be modified after SVD)
! Ptr s                : pointer to singular values
! Ptr v                : pointer to singular vectors
! Out nbMode           : number of modes selected
! Out nbSnap           : number of snapshots used in incremental algorithm
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iAlgoIni, iAlgoEnd, iEqua, iSnap, iAlgoSnap, iAlgo, k, iMode, iCoorRedu
    integer :: nbEqua, nbSing, nbModeMaxi, nbSnapResult
    integer :: nbSnapPrev, nbModePrev
    real(kind=8) :: tole_incr, tole_svd
    character(len=8) :: baseName
    real(kind=8) :: norm_q, norm_r
    integer(kind=4) :: info
    real(kind=8), pointer :: qi(:)   => null()
    real(kind=8), pointer :: ri(:)   => null()
    real(kind=8), pointer :: rt(:)   => null()
    real(kind=8), pointer :: vt(:)   => null()
    real(kind=8), pointer :: g(:)    => null()
    real(kind=8), pointer :: gt(:)   => null()
    real(kind=8), pointer :: kv(:)   => null()
    real(kind=8), pointer :: kt(:)   => null()
    integer(kind=4), pointer :: IPIV(:) => null()
    real(kind=8), pointer :: b(:)    => null()
    real(kind=8), pointer :: v_gamma(:)    => null()
    integer :: iret
    real(kind=8), pointer :: coorReduPrev(:) => null()
    character(len=24) :: mode, fieldName
    real(kind=8), pointer :: v_mode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    mode         = '&&IPOD_MODE'
    nbEqua       = base%mode%nbEqua
    nbModeMaxi   = paraPod%nb_mode_maxi
    nbSnapResult = paraPod%ds_snap%nb_snap
    tole_incr    = paraPod%tole_incr
    tole_svd     = paraPod%tole_svd
    ASSERT(paraPod%base_type .eq. '3D')
!
! - Properties of previous base
!
    baseName     = base%resultName
    nbModePrev   = base%nbMode
    nbSnapPrev   = base%nbSnap
    fieldName    = base%mode%fieldName
!
! - Get previous reduced coordinates when reuse 
!
    if (lReuse) then
        if (paraPod%tablReduCoor%lTablUser) then
            call tbexve(paraPod%tablReduCoor%tablUserName     ,&
                        paraPod%tablReduCoor%tablResu%tablSymbName, '&&COORHR')
        else
            call tbexve(paraPod%tablReduCoor%tablResu%tablName,&
                        paraPod%tablReduCoor%tablResu%tablSymbName, '&&COORHR')
        endif
        call jeveuo('&&COORHR', 'E', vr = coorReduPrev)
        call tbSuppressAllLines(paraPod%tablReduCoor%tablResu%tablName)
    endif
!
! - Allocate objects
!
    AS_ALLOCATE(vr = qi, size = nbEqua)
    AS_ALLOCATE(vr = ri, size = nbEqua)
    AS_ALLOCATE(vr = rt, size = nbEqua)
    if (.not. lReuse) then
        ASSERT(nbModePrev .eq. 0)
        ASSERT(nbSnapPrev .eq. 0)
    endif
    AS_ALLOCATE(vr = vt, size = nbEqua * (nbSnapResult + nbModePrev))
    AS_ALLOCATE(vr = gt, size = (nbSnapResult + nbModePrev) * (nbSnapResult + nbSnapPrev))
    AS_ALLOCATE(vr = g , size = (nbSnapResult + nbModePrev) * (nbSnapResult + nbSnapPrev))
!
! - Initialize algorithm
!
    if (lReuse) then
! ----- Add previous modes in v
        do iMode = 1, nbModePrev
            call rsexch(' ', baseName, fieldName, iMode, mode, iret)
            call jeveuo(mode(1:19)//'.VALE', 'L', vr = v_mode)
            do iEqua = 1, nbEqua
                vt(iEqua+nbEqua*(iMode-1)) = v_mode(iEqua)
            end do
        enddo
! ----- Add previous reduced coordinates in gT
        do iCoorRedu = 1, nbModePrev  * nbSnapPrev
            gt(iCoorRedu) = coorReduPrev(iCoorRedu)
        enddo
    else
! ----- Add first snap in v
        qi(1:nbEqua) = q(1:nbEqua)
        call norm_frobenius(nbEqua, qi, norm_q)
        if (norm_q .le. r8prem()) then
            norm_q = 1.d-16*sqrt(nbEqua*1.d0)
        endif
        vt(1:nbEqua) = qi(1:nbEqua)/norm_q
! ----- Add norm of first snap in gT
        gt(1)        = norm_q
    endif
!
! - Suppress previous result datastructure
!
    if (lReuse) then
        call detrsd('RESULTAT', baseName)
        call romBaseCreate(base, nbModePrev)
    endif
!
! - Set bounds of algorithm
!
    if (lReuse) then
        iAlgoSnap = nbModePrev
        iAlgoIni  = nbSnapPrev + 1
        iAlgoEnd  = nbSnapResult + nbSnapPrev
    else
        iAlgoSnap = 1
        iAlgoIni  = 2
        iAlgoEnd  = nbSnapResult
    endif
!
! - Main algorithm
!
    do iAlgo = iAlgoIni, iAlgoEnd
! ----- Get current snapshot
        if (lReuse) then
            do iEqua = 1, nbEqua
                qi(iEqua) = q(iEqua+nbEqua*(iAlgo-nbSnapPrev-1))
            enddo
        else
            do iEqua = 1, nbEqua
                qi(iEqua) = q(iEqua+nbEqua*(iAlgo-1))
            enddo
        endif

! ----- Compute norm of current snapshot
        call norm_frobenius(nbEqua, qi, norm_q)
        if (norm_q .le. r8prem()) then
            cycle
        endif

! ----- Compute {kt} = [v]^T {q} (projection of current snaphot on empiric base)
        AS_ALLOCATE(vr  = kt  , size = iAlgoSnap)
        call dgemm('T', 'N', iAlgoSnap, 1, nbEqua, 1.d0,&
                   vt, nbEqua,&
                   qi, nbEqua,&
                   0.d0, kt, iAlgoSnap)

! ----- Compute [kv] = [v]^T [v]
        AS_ALLOCATE(vr  = kv  , size = iAlgoSnap*iAlgoSnap)
        call dgemm('T', 'N', iAlgoSnap, iAlgoSnap, nbEqua, 1.d0,&
                   vt, nbEqua,&
                   vt, nbEqua,&
                   0.d0, kv, iAlgoSnap)

! ----- Solve [v]^T [v] {Y} = [v]^T {q} => {Y} are reduced coordinates
        AS_ALLOCATE(vi4 = IPIV, size = iAlgoSnap)
        call dgesv(iAlgoSnap, 1, kv, iAlgoSnap, IPIV, kt, iAlgoSnap, info)

! ----- Compute residu {r} = [v] {Y}
        call dgemm('N', 'N', nbEqua, 1, iAlgoSnap, 1.d0,&
                   vt, nbEqua,&
                   kt, iAlgoSnap,&
                   0.d0, rt, nbEqua)
        ri = qi - rt

! ----- Compute norm of residu
        call norm_frobenius(nbEqua, ri, norm_r)

! ----- Select vector or not ?
        if (norm_r/norm_q .ge. tole_incr) then
! --------- Add mode (residu !) at current iAlgoSnap iteration
            do iEqua = 1, nbEqua
                vt(iEqua + nbEqua*iAlgoSnap) = ri(iEqua)/norm_r
            enddo

! --------- Add singular value
! --------- G matrice rectangulaire en quatre morceaux.
! --------- Partie du bas: iAlgoSnap+1
! --------- Partie du haut: 1 => iAlgoSnap
! --------- Partie gauche: 1 => iAlgo -1
! --------- Partie droit: iAlgo

! --------- Valeurs haut-gauche
            do iSnap = 1, iAlgoSnap
                g(iSnap+(iAlgoSnap+1)*(iAlgo-1)) = kt(iSnap)
                do k = 1, iAlgo - 1
                    g(iSnap+(iAlgoSnap+1)*(k-1))= gt(iSnap+iAlgoSnap*(k-1))
                enddo
            enddo

! --------- Valeurs bas-gauche
            do k = 1, iAlgo - 1
                g((iAlgoSnap+1)*k)= 0.d0
            enddo

! --------- Valeur bas-droite
            g((iAlgoSnap + 1)*iAlgo) = norm_r

! --------- Valeurs haut-droite
            do k = 1, (iAlgoSnap + 1)*iAlgo
                gt(k) = g(k)
            enddo

! --------- Next snap
            iAlgoSnap = iAlgoSnap + 1

        else
            do iSnap = 1, iAlgoSnap
                gt(iSnap+iAlgoSnap*(iAlgo-1)) = kt(iSnap)
            enddo
        endif
        AS_DEALLOCATE(vr = kt)
        AS_DEALLOCATE(vr = kv)
        AS_DEALLOCATE(vi4 = IPIV)
    enddo
!
! - Deallocate objects
!
    AS_DEALLOCATE(vr = qi)
    AS_DEALLOCATE(vr = ri)
    AS_DEALLOCATE(vr = rt)
!
! - Final number of snapshots in base
!
    nbSnap = iAlgoEnd
!
! - Prepare matrix of reduced coordinates
!
    do iSnap = 1, iAlgoSnap * nbSnap
        g(iSnap) = gt(iSnap)
    end do
!
! - Compute SVD on matrix of reduced coordinates: Q = V S Wt
!
    call dbr_calcpod_svd(iAlgoSnap, nbSnap, g, s, b, nbSing)
!
! - Select empiric modes
!
    call dbr_calcpod_sele(nbModeMaxi, tole_svd, s, nbSing, nbMode)
!
! - Compute matrix of singular vector: V <= V * B (dim : [nbMode x nbEqua] )
!
    AS_ALLOCATE(vr = v, size = nbEqua*nbMode)
    call dgemm('N', 'N', nbEqua, nbMode, iAlgoSnap, 1.d0,&
               vt, nbEqua,&
               b, iAlgoSnap,&
               0.d0, v, nbEqua)
!
! - Compute reduced coordinates G <= B^T G (dim : [nbMode x nbSnap] )
!
    AS_ALLOCATE(vr = v_gamma, size = nbMode*nbSnap) 
    call dgemm('T', 'N', nbMode, nbSnap, iAlgoSnap, 1.d0,&
               b, iAlgoSnap,&
               gt, iAlgoSnap,&
               0.d0, v_gamma, nbMode)
!
! - Save the reduced coordinates in a table
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_39', ni = 2, vali = [nbSnap, nbMode])
    endif
    do iSnap = 1, nbSnap
        call romTableSave(paraPod%tablReduCoor%tablResu, nbMode, v_gamma,&
                          nume_snap_ = iSnap)
    end do
!
! - Debug print
!
    call utmess('I', 'ROM7_14', si = nbSnap)
!
! - Clean
!
    AS_DEALLOCATE(vr = v_gamma)
    AS_DEALLOCATE(vr = vt)
    AS_DEALLOCATE(vr = gt)
    AS_DEALLOCATE(vr = g)
    AS_DEALLOCATE(vr = b)
!
end subroutine
