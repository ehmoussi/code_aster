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
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
subroutine mmopti(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mcomce.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/detrsd.h"
#include "asterfort/apinfi.h"
#include "asterfort/apvect.h"
#include "asterfort/cfnumm.h"
#include "asterfort/mmelty.h"
#include "asterfort/armin.h"
#include "asterfort/infdbg.h"
#include "asterfort/mmfield_prep.h"
#include "asterfort/mmextm.h"
#include "asterfort/mmvalp_scal.h"
#include "asterfort/apinfr.h"
#include "asterfort/mminfm.h"
#include "asterfort/mminfi.h"
#include "asterfort/mminfr.h"
#include "asterfort/mmnorm.h"
#include "asterfort/mminfl.h"
#include "asterfort/cfdisi.h"
#include "asterfort/utmess.h"
#include "asterc/r8prem.h"
#include "blas/ddot.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue method - Initial options (*_INIT)
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: disp_init, cnscon
    real(kind=8) :: jeusgn, tau1(3), tau2(3), norm(3), noor
    real(kind=8) :: mlagc(9), pres_cont, flag_cont
    integer :: i_zone, i_elem_slav, i_poin_appa, i_poin_elem, i_cont_poin
    integer :: nb_cont_zone, nb_poin_elem, nb_elem_slav, model_ndim
    integer :: nb_cont_init, nb_cont_excl
    integer :: elem_slav_indx, elem_slav_nume, elem_slav_nbno
    real(kind=8) :: vectpm(3), seuil_init, epsint, armini, ksipr1, ksipr2
    aster_logical :: l_node_excl
    integer :: jdecme
    integer :: cont_init, type_inte, pair_type
    aster_logical :: l_veri, l_gliss, l_auto_seuil
    integer :: ndexfr
    character(len=8) :: elem_slav_type
    character(len=24) :: sdappa
    integer :: ztabf
    character(len=24) :: sdcont_tabfin
    real(kind=8), pointer :: v_sdcont_tabfin(:) => null()
    integer  ::  elem_mast_nume,elem_mast_nbno
    character(len=8) :: elem_mast_type
    character(len=19) :: oldgeo
    real(kind=8) :: elem_mast_coor(27),lenght_master_elem,lenght_master_elem_init,milieu(3)
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','CONTACT5_18')
    endif
!
! - Initializations
!
    cnscon       = '&&MMOPTI.CNSCON'
    i_poin_appa  = 1
    i_cont_poin  = 1
    nb_cont_init = 0
    nb_cont_excl = 0
    lenght_master_elem      = 0.0
    milieu      = 0.0
    lenght_master_elem_init = -1
!
! - Parameters
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO')
    model_ndim   = cfdisi(ds_contact%sdcont_defi,'NDIM') 
!
! - Datastructure for contact solving
!
    sdcont_tabfin = ds_contact%sdcont_solv(1:14)//'.TABFIN'
    call jeveuo(sdcont_tabfin, 'E', vr = v_sdcont_tabfin)
    ztabf = cfmmvd('ZTABF')
!
! - Pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
!
! - Tolerance for CONTACT_INIT
!
    armini = armin(mesh)
    epsint = 1.d-6*armini
    ds_contact%arete_min = armini
    ds_contact%arete_max = armini
!
! - Initial Geometric coordinates
!
    oldgeo = mesh//'.COORDO'
!
! - Preparation for SEUIL_INIT
!
    do i_zone = 1, nb_cont_zone
        l_auto_seuil = mminfl(ds_contact%sdcont_defi,'SEUIL_AUTO', i_zone)
        if (l_auto_seuil) then
            disp_init =  ds_contact%sdcont_solv(1:14)//'.INIT'
            call mmfield_prep(disp_init, cnscon,&
                              l_sort_ = .true._1, nb_cmp_ = 1, list_cmp_ = ['LAGS_C  '])
            goto 30
        endif
    end do
 30 continue
!
! - Loop on contact zones
!
    do i_zone = 1, nb_cont_zone
!
! ----- Parameters of zone
!
        jdecme       = mminfi(ds_contact%sdcont_defi,'JDECME'        , i_zone)
        nb_elem_slav = mminfi(ds_contact%sdcont_defi,'NBMAE'         , i_zone)
        type_inte    = mminfi(ds_contact%sdcont_defi,'INTEGRATION'   , i_zone)
        l_gliss      = mminfl(ds_contact%sdcont_defi,'GLISSIERE_ZONE', i_zone)
        l_auto_seuil = mminfl(ds_contact%sdcont_defi,'SEUIL_AUTO'    , i_zone)
        seuil_init   = mminfr(ds_contact%sdcont_defi,'SEUIL_INIT'    , i_zone)
        seuil_init   = -abs(seuil_init)
        cont_init    = mminfi(ds_contact%sdcont_defi,'CONTACT_INIT'  , i_zone)
!
! ----- No computation: no contact point
!
        l_veri = mminfl(ds_contact%sdcont_defi,'VERIF', i_zone)
        if (l_veri) then
            nb_poin_elem = mminfi(ds_contact%sdcont_defi, 'NBPT', i_zone)
            i_poin_appa  = i_poin_appa + nb_poin_elem
            goto 25
        endif
!
! ----- Loop on slave elements
!
        do i_elem_slav = 1, nb_elem_slav
!
! --------- Slave element index in contact datastructure
!
            elem_slav_indx = jdecme + i_elem_slav
!
! --------- Informations about slave element
!
            call cfnumm(ds_contact%sdcont_defi, elem_slav_indx, elem_slav_nume)
            call mmelty(mesh, elem_slav_nume, elem_slav_type, elem_slav_nbno)
!
! --------- Number of integration points on element
!
            call mminfm(elem_slav_indx, ds_contact%sdcont_defi, 'NPTM'  , nb_poin_elem)
!
! --------- SANS_GROUP_NO_FR or SANS_NOEUD_FR ?
!
            call mminfm(elem_slav_indx, ds_contact%sdcont_defi, 'NDEXFR', ndexfr)
!
! --------- Loop on integration points
!
            do i_poin_elem = 1, nb_poin_elem
!
! ------------- Current master element
!
                elem_mast_nume = nint(v_sdcont_tabfin(ztabf*(i_cont_poin-1)+3))
!
! --------- Get coordinates of master element
!
                call mcomce(mesh          , oldgeo, elem_mast_nume, elem_mast_coor, elem_mast_type,&
                            elem_mast_nbno)
    ! Compute the minima lenght of the master element in the current zone
!                 write (6,*) "elem_mast_type",elem_mast_type
                 
                 if ((elem_mast_type(1:2) .eq. 'SE') ) then   
                 ! On calcule la distance des noeuds sommets                      
                    lenght_master_elem      = 0.0                
                    lenght_master_elem = sqrt(                                            &
                                abs((elem_mast_coor(4)-elem_mast_coor(1)))**2.d0 +&
                                abs((elem_mast_coor(5)-elem_mast_coor(2)))**2.d0 +&
                                abs((elem_mast_coor(6)-elem_mast_coor(3)))**2.d0 &
                                 )
                 elseif  ((elem_mast_type(1:2) .eq. 'TR')) then                      
                     lenght_master_elem      = 0.0 
                 ! On calcule la mediane
                    milieu(1) =  (elem_mast_coor(1)+elem_mast_coor(4))*0.5
                    milieu(2) =  (elem_mast_coor(2)+elem_mast_coor(5))*0.5
                    milieu(3) =  (elem_mast_coor(3)+elem_mast_coor(6))*0.5               
                    lenght_master_elem = sqrt(                                            &
                                abs((elem_mast_coor(7)-milieu(1)))**2.d0 +&
                                abs((elem_mast_coor(8)-milieu(2)))**2.d0 +&
                                abs((elem_mast_coor(9)-milieu(3)))**2.d0 &
                                 )   
                    
                 elseif  ((elem_mast_type(1:2) .eq. 'QU')) then                   
                    lenght_master_elem      = 0.0  
                 ! On calcule la moyenne des diagonale            
                    lenght_master_elem = sqrt(                                            &
                                abs((elem_mast_coor(7)-elem_mast_coor(1)))**2.d0 +&
                                abs((elem_mast_coor(8)-elem_mast_coor(2)))**2.d0 +&
                                abs((elem_mast_coor(9)-elem_mast_coor(3)))**2.d0 &
                                 )  + &
                                 sqrt(                                            &
                                abs((elem_mast_coor(10)-elem_mast_coor(4)))**2.d0 +&
                                abs((elem_mast_coor(11)-elem_mast_coor(5)))**2.d0 +&
                                abs((elem_mast_coor(12)-elem_mast_coor(6)))**2.d0 &
                                 )  
                 endif
                 
                ! On cherche a initialiser lenght_master_elem_init,ds_contact%arete_min,max
                ! avec la premiere arete non nulle de la zone maitre
                ! La valeur initiale est la longueur de la premiere maille maitre de longueur 
                ! non nulle.                
                if (lenght_master_elem_init .eq. -1) then
                    lenght_master_elem_init = lenght_master_elem
                    ds_contact%arete_min = lenght_master_elem_init
                    ds_contact%arete_max = lenght_master_elem_init
                endif
                    
                if ( (lenght_master_elem_init .le. 0.0d0 )) then 
                    lenght_master_elem_init = -1
                elseif (i_poin_elem .ge. 2 .and. lenght_master_elem_init .ne. -1) then 
                    if ( (lenght_master_elem .lt. ds_contact%arete_min)  ) then
                        ds_contact%arete_min = lenght_master_elem 
                    endif
                    if ( (lenght_master_elem .gt. ds_contact%arete_max)  ) then
                        ds_contact%arete_max = lenght_master_elem 
                    endif
                 
                endif
                
!                write (6,*) "armin,armax",ds_contact%arete_min,ds_contact%arete_max
                 
!
! ------------- Get pairing info
!
                call apinfr(sdappa, 'APPARI_PROJ_KSI1', i_poin_appa, ksipr1)
                call apinfr(sdappa, 'APPARI_PROJ_KSI2', i_poin_appa, ksipr2)
                call apinfi(sdappa, 'APPARI_TYPE'     , i_poin_appa, pair_type)
                call apvect(sdappa, 'APPARI_VECTPM'   , i_poin_appa, vectpm)   
!
! ------------- No nodal pairing !
!
                ASSERT(pair_type .ne. 1)
!
! ------------- Definition of local basis
!
                tau1(1) = v_sdcont_tabfin(ztabf*(i_cont_poin-1)+8)
                tau1(2) = v_sdcont_tabfin(ztabf*(i_cont_poin-1)+9)
                tau1(3) = v_sdcont_tabfin(ztabf*(i_cont_poin-1)+10)
                tau2(1) = v_sdcont_tabfin(ztabf*(i_cont_poin-1)+11)
                tau2(2) = v_sdcont_tabfin(ztabf*(i_cont_poin-1)+12)
                tau2(3) = v_sdcont_tabfin(ztabf*(i_cont_poin-1)+13)
                call mmnorm(model_ndim, tau1, tau2, norm, noor)
!
! ------------- Excluded nodes
!
                l_node_excl = v_sdcont_tabfin(ztabf*(i_cont_poin-1)+19) .gt. 0.d0
!
! ------------- Signed gap
!
                jeusgn = ddot(model_ndim, norm, 1, vectpm, 1)
!
! ------------- Option: SEUIL_INIT
!
                if (l_auto_seuil) then
                    call mmextm(ds_contact%sdcont_defi, cnscon, elem_slav_indx, mlagc)
                    call mmvalp_scal(model_ndim, elem_slav_type, elem_slav_nbno, ksipr1,&
                                     ksipr2    , mlagc         , pres_cont)
                    v_sdcont_tabfin(ztabf*(i_cont_poin-1)+17) = pres_cont
                else
                    v_sdcont_tabfin(ztabf*(i_cont_poin-1)+17) = seuil_init
                endif
!
! ------------- Option: CONTACT_INIT
!
                flag_cont = 0.d0
                if (cont_init .eq. 2) then
! ----------------- Only interpenetrated points
                    if (jeusgn .le. epsint) then
                        flag_cont = 1.d0
                    endif
                else if (cont_init .eq. 1) then
! ----------------- All points
                    flag_cont = 1.d0
                    nb_cont_init = nb_cont_init + 1
                else if (cont_init .eq. 0) then
! ----------------- No initial contact
                    flag_cont = 0.d0
                else
                    ASSERT(.false.)
                endif
!
! ------------- Option: GLISSIERE
!
                if (l_gliss) then
                    if (cont_init .eq. 1) then
                        v_sdcont_tabfin(ztabf*(i_cont_poin-1)+18) = 1.d0          
                    endif
                    if (cont_init .eq. 2 .and. (jeusgn .le. epsint)) then
                        v_sdcont_tabfin(ztabf*(i_cont_poin-1)+18) = 1.d0        
                    endif
                endif
!
! ------------- Excluded nodes => no contact !
!
                if (l_node_excl) then
                    flag_cont = 0.d0
                    nb_cont_excl = nb_cont_excl + 1
                endif
!
! ------------- Save initial contact
!    
                v_sdcont_tabfin(ztabf*(i_cont_poin-1)+23) = flag_cont
!
! ------------- Next contact point
!
                i_poin_appa  = i_poin_appa + 1
                i_cont_poin  = i_cont_poin + 1
            end do
        end do
 25     continue
    end do
!
    call utmess('I', 'CONTACT3_5', ni = 2 , vali = [nb_cont_init, nb_cont_excl])
!
    call detrsd('CHAM_NO_S', cnscon)
!
end subroutine
