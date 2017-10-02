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

subroutine dtmeigen(sd_dtm_, sd_int_, oldcase, buffdtm, buffint)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtmeigen : Calculate the new eigen values for the modified matrices in the
!            implicit treatment of non linearities
!
#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterc/r8vide.h"
#include "asterfort/crsmos.h"
#include "asterfort/detrsd.h"
#include "asterfort/dtmcase_coder.h"
#include "asterfort/dtmeigen_fsi.h"
#include "asterfort/dtmget.h"
#include "asterfort/dtminfo_choc.h"
#include "asterfort/intget.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedup1.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/mrmult.h"
#include "asterfort/mtdscr.h"
#include "asterfort/nmop45.h"
#include "asterfort/omega2.h"
#include "asterfort/nummo1.h"
#include "asterfort/prmama.h"
#include "asterfort/rsorac.h"
#include "asterfort/utimsd.h"
#include "asterfort/utmess.h"
#include "asterfort/vpcres.h"
#include "asterfort/vprecu.h"
#include "asterfort/vpnorm.h"
#include "asterfort/wkvect.h"
#include "blas/ddot.h"
#include "blas/dcopy.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"

!
!   -0.1- Input/output arguments
    character(len=*) , intent(in) :: sd_dtm_
    character(len=*) , intent(in) :: sd_int_
    integer          , intent(in) :: oldcase
    integer, pointer              :: buffdtm(:)
    integer, pointer              :: buffint(:)
!
!   -0.2- Local variables
    integer               :: nbmode, i, j, count, jrefa, nbnoli, nbvect, nbvec2, nbrss, maxitr
    integer               :: jdesc, lmatm, lmatk, lmatc, jbase, defo, nddle, nsta
    integer               :: ibid, nlcase, iret, fsichoc, info, ifm, nbborn
    real(kind=8)          :: time, bande(2), r8bid, alpha, tolsor, precsh, omecor, precdc, fcorig
    character(len=1)      :: k1bid
    character(len=4)      :: mod45
    character(len=7)      :: casek7, case0k7
    character(len=8)      :: sd_dtm, sd_int, modmec, typrof, modes, method, sdstab, k8bid
    character(len=14)     :: nugene, nopara(9)
    character(len=16)     :: optiof, typres, k16bid
    character(len=19)     :: matmass, matrigi, matamor, raide2, masse2, eigsol, k19bid
    character(len=24)     :: stomor, solver, base_jv, kvali, kvalr, kvalk, add_jv, k24bid
!
    real(kind=8), pointer :: base(:)    => null()
    real(kind=8), pointer :: mat_v(:)   => null()
    real(kind=8), pointer :: phi0_v(:)  => null()
    real(kind=8), pointer :: mgen(:)    => null()
    real(kind=8), pointer :: kgen(:)    => null()
    real(kind=8), pointer :: agen(:)    => null()
    real(kind=8), pointer :: mvalm(:)   => null()
    real(kind=8), pointer :: kvalm(:)   => null()
    real(kind=8), pointer :: avalm(:)   => null()

    real(kind=8), pointer :: mgen2(:)   => null()
    real(kind=8), pointer :: kgen2(:)   => null()
    real(kind=8), pointer :: agen2(:)   => null()
    real(kind=8), pointer :: aful2(:)   => null()

    real(kind=8), pointer :: coefr(:)   => null()
    real(kind=8), pointer :: valr(:)    => null()

    real(kind=8), pointer :: c_flu(:)   => null()


!
#define mat(row,col) mat_v((col-1)*nbmode+row)
#define m(row,col) mgen((col-1)*nbmode+row)
#define k(row,col) kgen((col-1)*nbmode+row)
#define a(row,col) agen((col-1)*nbmode+row)

#define a2(row,col) aful2((col-1)*nbmode+row)

!
    data  nopara /&
     &  'NUME_MODE' , 'NORME    '  , 'FREQ       ' ,&
        'FREQ     ' , 'OMEGA2   '  , 'AMOR_REDUIT' ,&
        'MASS_GENE' , 'RIGI_GENE'  , 'AMOR_GENE  '  /
!
!   0 - Initializations
    sd_dtm  = sd_dtm_
    sd_int  = sd_int_


    call dtmget(sd_dtm, _NL_CASE, iscal=nlcase, buffer=buffdtm)
    call dtmcase_coder (nlcase, casek7)

    base_jv  = sd_dtm // '.PRJ_BAS.'//casek7
    call jeexin(base_jv, iret)
    if (iret.eq.0) then
!
!       1 - Prepare the matrices for a nmop45 call

!       1.1 - Create a nume_ddl_gene with the initial basis in full profile
        call dtmget(sd_dtm, _BASE_MOD, kscal=modmec, buffer=buffdtm)
        call dtmget(sd_dtm, _NB_MODES, iscal=nbmode, buffer=buffdtm)
        nugene  = '&&DTMNUG'
        matmass = '&&DTMMAG'
        matrigi = '&&DTMRIG'
        matamor = '&&DTMAMO'

        call jeexin(nugene//'.NUME.DESC', iret)
        if (iret.eq.0) then
            typrof = 'PLEIN'
            call nummo1(nugene, modmec, nbmode, typrof)
            stomor=nugene//'     .SMOS'
            call crsmos(stomor, typrof, nbmode)
        end if

!       1.2 - Create the appropriate matrix layouts, if needed, in full storage format
        call jeexin(matmass//'.REFA', iret)
        if (iret.eq.0) then
!           1.2 - Copy the temporary mass and stiffness matrices in a Morse format
            call dtmget(sd_dtm, _SOLVER, savejv=solver)

!       --- .REFA
            call wkvect(matmass//'.REFA', 'V V K24', 20, jrefa)
            zk24(jrefa-1+1) = modmec
            zk24(jrefa-1+2) = nugene
            zk24(jrefa-1+7) = solver(1:19)
            zk24(jrefa-1+9) = 'MS'
            zk24(jrefa-1+10)= 'GENE'
            zk24(jrefa-1+11)= 'MPI_COMPLET'
            call jedup1(matmass//'.REFA', 'V', matrigi//'.REFA')
            call jedup1(matmass//'.REFA', 'V', matamor//'.REFA')

!           --- .DESC
            call wkvect(matmass//'.DESC', 'V V I', 3, jdesc)
            zi(jdesc-1+1) = 2
            zi(jdesc-1+2) = nbmode
            call jedup1(matmass//'.DESC', 'V', matrigi//'.DESC')
            call jedup1(matmass//'.DESC', 'V', matamor//'.DESC')

!           --- .VALM
            call jecrec(matmass//'.VALM', 'V V R', 'NU', 'DISPERSE', 'CONSTANT', 1)
            call jeecra(matmass//'.VALM', 'LONMAX', nbmode*(nbmode+1)/2)
            call jecroc(jexnum(matmass//'.VALM', 1))

            call jecrec(matrigi//'.VALM', 'V V R', 'NU', 'DISPERSE', 'CONSTANT', 1)
            call jeecra(matrigi//'.VALM', 'LONMAX', nbmode*(nbmode+1)/2)
            call jecroc(jexnum(matrigi//'.VALM', 1))

            call jecrec(matamor//'.VALM', 'V V R', 'NU', 'DISPERSE', 'CONSTANT', 1)
            call jeecra(matamor//'.VALM', 'LONMAX', nbmode*(nbmode+1)/2)
            call jecroc(jexnum(matamor//'.VALM', 1))
        end if

        call jeveuo(jexnum(matmass//'.VALM', 1), 'E', vr=mvalm)
        call jeveuo(jexnum(matrigi//'.VALM', 1), 'E', vr=kvalm)
        call jeveuo(jexnum(matamor//'.VALM', 1), 'E', vr=avalm)

        if (nbmode.gt.1) then
            call intget(sd_int, MASS_FUL, iocc=1, lonvec=iret, buffer=buffint)
            if (iret.eq.0) then
                call intget(sd_int, MASS_DIA, iocc=1, vr=mgen, buffer=buffint)
                count = 1
                do i = 1, nbmode
                    do j = 1, i
                        mvalm(count) = 0.d0
                        if (i.eq.j) mvalm(count) = mgen(i)
                        count = count + 1
                    end do
                end do
            else
                call intget(sd_int, MASS_FUL, iocc=1, vr=mgen, buffer=buffint)
                count = 1
                do i = 1, nbmode
                    do j = 1, i
                        mvalm(count) = m(i,j)
                        count = count + 1
                    end do
                end do
            end if

            call intget(sd_int, RIGI_FUL, iocc=1, lonvec=iret, buffer=buffint)
            if (iret.eq.0) then
                call intget(sd_int, RIGI_DIA, iocc=1, vr=kgen, buffer=buffint)
                count = 1
                do i = 1, nbmode
                    do j = 1, i
                        kvalm(count) = 0.d0
                        if (i.eq.j) kvalm(count) = kgen(i)
                        count = count + 1
                    end do
                end do
            else
                call intget(sd_int, RIGI_FUL, iocc=1, vr=kgen, buffer=buffint)
                count = 1
                do i = 1, nbmode
                    do j= 1, i
                        kvalm(count) = k(i,j)
                        count = count + 1
                    end do
                end do
            end if

            call intget(sd_int,  AMOR_FUL, iocc=1, lonvec=iret, buffer=buffint)
            call dtmget(sd_dtm, _FSI_ZET0, vr=c_flu, buffer=buffdtm)
            if (iret.eq.0) then
                call intget(sd_int, AMOR_DIA, iocc=1, vr=agen, buffer=buffint)
                count = 1
                do i = 1, nbmode
                    do j = 1, i
                        avalm(count) = 0.d0
                        if (i.eq.j) avalm(count) = agen(i) - mvalm(count)*c_flu(i)
                        count = count + 1
                    end do
                end do
            else
                call intget(sd_int, AMOR_FUL, iocc=1, vr=agen, buffer=buffint)
                count = 1
                do i = 1, nbmode
                    do j= 1, i
                        avalm(count) = a(i,j)
                        if (i.eq.j) avalm(count) = avalm(count) - mvalm(count)*c_flu(i)
                        count = count + 1
                    end do
                end do
            end if
        else
            call intget(sd_int,  RIGI_DIA, iocc=1, rvect=kvalm, buffer=buffint)
            call intget(sd_int,  MASS_DIA, iocc=1, rvect=mvalm, buffer=buffint)
            call intget(sd_int,  AMOR_DIA, iocc=1, rvect=avalm, buffer=buffint)
            call dtmget(sd_dtm, _FSI_ZET0, vr=c_flu, buffer=buffdtm)
            avalm(1) = avalm(1) - mvalm(1)*c_flu(1)
        end if
!
        call intget(sd_int, TIME, iocc=1, rscal=time, buffer=buffint)
        call dtmget(sd_dtm, _NB_NONLI, iscal=nbnoli, buffer=buffdtm)
        call utmess('I', 'DYNAMIQUE_90', sr=time)
        call dtminfo_choc(nlcase, nbnoli)
        call utmess('I', 'DYNAMIQUE_94', sr=time)
!
!       2 - Call nmop45, calculate a new basis, normalize with respect to the mass
!
!       2.0 - Initialize data structure eigsol to prepare the nmop45 computation
! BANDE MODALE EN DUR
        bande(1)=0.d0
        bande(2)=0.d0
        modes='&&DTMMOD'
        eigsol='&&MODINT.EIGSOL'
!
        k1bid=''
        k8bid=''
        k16bid=''
        k19bid=''
        k24bid=''
        ibid=isnnem()
        r8bid=r8vide()
        typres = 'DYNAMIQUE'
        method = 'SORENSEN'
! MATR_A
        raide2=matrigi
! MATR_B
        masse2=matmass
! OPTION MODALE EN DUR
        optiof='PLUS_PETITE'
! DIM_SOUS_ESPACE EN DUR
        nbvect=0
! COEF_SOUS_ESPACE EN DUR 
        nbvec2=2
! NMAX_ITER_SHIFT EN DUR
        nbrss = 5
! PARA_ORTHO_SOREN EN DUR       
        alpha = 0.717d0
! NMAX_ITER_SOREN EN DUR
        maxitr = 200
! PREC_SOREN EN DUR
        tolsor = 0.d0
! CALC_FREQ/FLAMB/PREC_SHIFT EN DUR
        precsh = 5.d-2
! SEUIL_FREQ/CRIT EN DUR
        fcorig = 1.d-2
        omecor = omega2(fcorig)
! VERI_MODE/PREC_SHIFT EN DUR
        precdc = 5.d-2
        nbborn=1
        call vpcres(eigsol, typres, raide2, masse2, k19bid, optiof, method, k16bid, k8bid,&
                    k19bid, k16bid, k16bid, k1bid, k16bid, nbmode, nbvect, nbvec2, nbrss,&
                    nbborn, ibid, ibid, ibid, ibid, maxitr, bande, precsh, omecor, precdc,&
                    r8bid, r8bid, r8bid, r8bid, r8bid, tolsor, alpha)
        
!       2.1 - Mode calculation
        defo=0
        mod45='VIBR'
        nddle=0
        sdstab='&&DUMMY'
        nsta=0
        call nmop45(eigsol, defo, mod45, k24bid, nddle, modes, sdstab, k24bid, nsta)

!       2.2 - Mode normalising using MASS_GENE option

        kvali = '&&DTMEIG.GRAN_MODAL_I'
        kvalr = kvali(1:20)//'R'
        kvalk = kvali(1:20)//'K'
        AS_ALLOCATE(vr=coefr, size=nbmode)

        call mtdscr(matmass)
        call jeveuo(matmass//'.&INT', 'E', lmatm)

        call vprecu(modes, 'DEPL', -1, zi(1), base_jv,&
                    9, nopara(1), kvali, kvalr, kvalk,&
                    zi(1), ibid, zk8(1), zi(1), zi(1),&
                    zi(1))
        call jeveuo(base_jv , 'E', jbase)
        call jeveuo(kvalr   , 'E', vr=valr)
        call vpnorm('MASS_GENE', 'NON', lmatm, nbmode, nbmode,&
                    zi(1), zr(jbase), valr, [0.d0,0.d0,0.d0],&
                    0, 0, coefr)
!
!       3 - Project the stiffness and damping matrices onto this basis
!           (The mass matrix is set to the identity)
!           Calculating    [Phi]^t * [ K ] * [Phi]
!                                    -- mrmult ---
!                          ------- ddot ----------

        call wkvect(sd_dtm // '.PRJ_MAS.'// casek7, 'V V R', nbmode, vr=mgen2)
        call wkvect(sd_dtm // '.PRJ_RIG.'// casek7, 'V V R', nbmode, vr=kgen2)
        call wkvect(sd_dtm // '.PRJ_AMO.'// casek7, 'V V R', nbmode, vr=agen2)
        call wkvect(sd_dtm // '.PRJ_AM2.'// casek7, 'V V R', nbmode*nbmode, vr=aful2)

!       ------------------------------------------------------------------------------
!       --- This can be used to verify that the norm_mode step was successful, giving
!          thus a diagonal mass matrix == Identity
!       ------------------------------------------------------------------------------
!       do i = 1, nbmode
!           call mrmult('ZERO', lmatm, zr(jbase+(i-1)*nbmode), coefr, 1,&
!                       .true._1)
!           do j = 1, nbmode
!               m2(i,j) = ddot(nbmode, zr(jbase+(j-1)*nbmode), 1, coefr, 1)
!           end do
!       end do

!       --- The mass matrix is filled manually
        do i = 1, nbmode
            mgen2(i) = 1.d0
        end do

!       --- The stiffness matrix is calculed, it should be diagonal and containing
!           omega^2 (i=1->n) on the diagonal (orthogonality properties of the eigen vectors)
        call mtdscr(matrigi)
        call jeveuo(matrigi//'.&INT', 'E', lmatk)
        do i = 1, nbmode
            call mrmult('ZERO', lmatk, zr(jbase+(i-1)*nbmode), coefr, 1,&
                        .true._1)
            kgen2(i) = ddot(nbmode, zr(jbase+(i-1)*nbmode), 1, coefr, 1)
        end do

!       --- The damping matrix is full
        call mtdscr(matamor)
        call jeveuo(matamor//'.&INT', 'E', lmatc)
        do i = 1, nbmode
            call mrmult('ZERO', lmatc, zr(jbase+(i-1)*nbmode), coefr, 1,&
                        .true._1)
            do j = 1, nbmode
                a2(i,j) = ddot(nbmode, zr(jbase+(j-1)*nbmode), 1, coefr, 1)
                if (i .eq. j) agen2(i) = a2(i,j)
            end do
        end do

        add_jv = sd_dtm // '.ADDED_K.'//casek7
        call jeveuo(add_jv, 'E', vr=mat_v)
        do i = 1, nbmode
            mat(i,i) = kgen2(i)
            do j = i+1, nbmode
                mat(i,j) = 0.d0
            end do
        end do
        nullify(mat_v)
        add_jv = sd_dtm // '.ADDED_C.'//casek7
        call jeveuo(add_jv, 'E', vr=mat_v)
        call dcopy(nbmode*nbmode, aful2, 1, mat_v, 1)
        nullify(mat_v)

        call jedetr(kvali)
        call jedetr(kvalr)
        call jedetr(kvalk)
        call detrsd('RESULTAT', modes)
        call detrsd('RESULTAT', '&&DUMMY ')

        AS_DEALLOCATE(vr=coefr)

!       --- At this point, the new eigen vectors are given as function of the
!           preceding basis

!       --- If the preceding case is not <0> (i.e. corresponding to no chocs at all)
!           then their is nothing to do, however, if the preceding case is non lineair
!           i.e. case != 0, then we need to transform the eigen vector in term of the
!           original coordinates

        if (oldcase.ne.0) then
            call dtmcase_coder(oldcase, case0k7)
            base_jv = sd_dtm // '.PRJ_BAS.'// case0k7
            call jeveuo(base_jv, 'E', vr=phi0_v)
            AS_ALLOCATE(vr=base, size=nbmode*nbmode)
            call prmama(1, phi0_v, nbmode, nbmode, nbmode,&
                        zr(jbase), nbmode, nbmode, nbmode, base,&
                        nbmode, nbmode, nbmode, iret)
            call dcopy(nbmode*nbmode, base, 1, zr(jbase), 1)
            AS_DEALLOCATE(vr=base)
        end if

        call dtmget(sd_dtm, _FSI_CASE, iscal=fsichoc, buffer=buffdtm)
        if (fsichoc.eq.1) then
            call dtmeigen_fsi(sd_dtm, buffdtm)
        end if
    else

        call infmaj()
        call infniv(ifm, info)
        if (info.eq.2) then
            call intget(sd_int, TIME, iocc=1, rscal=time, buffer=buffint)
            call dtmget(sd_dtm, _NB_NONLI, iscal=nbnoli, buffer=buffdtm)
            call utmess('I', 'DYNAMIQUE_90', sr=time)
            call dtminfo_choc(nlcase, nbnoli)
        end if
    end if

end subroutine
