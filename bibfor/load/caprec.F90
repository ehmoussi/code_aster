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

subroutine caprec(load, mesh, ligrmo, vale_type)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/indik8.h"
#include "asterc/r8gaem.h"
#include "asterfort/aflrch.h"
#include "asterfort/armin.h"
#include "asterfort/assert.h"
#include "asterfort/cescar.h"
#include "asterfort/char_rcbp_cabl.h"
#include "asterfort/char_rcbp_lino.h"
#include "asterfort/chsfus.h"
#include "asterfort/copisd.h"
#include "asterfort/craglc.h"
#include "asterfort/cragch.h"
#include "asterfort/dismoi.h"
#include "asterfort/solide_tran.h"
#include "asterfort/detrsd.h"
#include "asterfort/drz12d.h"
#include "asterfort/drz13d.h"
#include "asterfort/exisdg.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/nbec.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/alcart.h"
#include "asterfort/nocart.h"
#include "asterfort/tecart.h"
!
!
    character(len=8), intent(in) :: load
    character(len=8), intent(in) :: mesh
    character(len=19), intent(in) :: ligrmo
    character(len=4), intent(in) :: vale_type
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! Keyword = 'RELA_CINE_BP'
!
! --------------------------------------------------------------------------------------------------
!
!
! In  mesh      : name of mesh
! In  load      : name of load
! In  ligrmo    : list of elements in model
! In  vale_type : affected value type (real, complex or function)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywordfact
    integer :: nliai, ndimmo
    real(kind=8) :: dist_mini, dist
    complex(kind=8) :: cbid
    character(len=8) :: k8bid, model, answer
    integer :: n1, iocc, iret, ibid
    integer :: nbrela
    character(len=19) :: list_rela, list_rela_tmp, list_rela_old
    character(len=2) :: lagr_type
    character(len=8) :: cmp_name
    integer :: dim
    integer :: cmp_index_dx, cmp_index_dy, cmp_index_dz
    integer :: cmp_index_drx, cmp_index_dry, cmp_index_drz
    character(len=8) :: nomg_depl, nomg_sief, nom_noeuds_tmp(4)
    integer :: nb_cmp_depl, nb_cmp_sief
    integer :: j_cmp_depl, j_cmp_sief
    integer :: nbec_depl, nbec_sief
    aster_logical :: l_sigm_bpel, l_rela_cine
    character(len=24) :: list_cabl, list_anc1, list_anc2
    integer :: nb_cabl, nb_anc1, nb_anc2
    integer :: jlicabl, jlianc1, jlianc2
    character(len=24) :: list_node
    integer :: nb_node, jlino
    character(len=8) :: cabl_prec
    character(len=19) :: cabl_sigm, ligrch
    aster_logical :: l_rota_2d, l_rota_3d
    integer :: i_cabl, i_ancr, i_no, nume_node
    integer :: nb_elem
    integer :: jprnm
    character(len=24) :: name_ancr, name_anc1, name_anc2
    integer :: nume_cabl, nume_cabl0
    integer :: jlces, jll, jlr, nbchs
    integer, pointer :: rlnr(:) => null()
    integer, pointer :: rlpo(:) => null()
    character(len=8), pointer :: rltc(:) => null(), rltv(:) => null()
    integer :: nbteli, nbteli_total
    integer :: pass 
    character(len=4) :: typval, typcoe
    character(len=7) :: typcha
    integer :: nbcmp, numa, iivale, nma, icmp, ima, nbma, nbval
    integer :: jsief, nsief
    integer, pointer :: sigmnuma(:) => null()
    aster_logical :: l_prealloc
    real(kind=8), pointer :: sigmvale(:) => null()
    character(len=8), pointer :: ncmp(:) => null()
    character(len=8), dimension(3) :: sigmcmp
    integer :: jdesc,jnoma, jncmp,jnoli,jvale,jvalv,jnocmp,ncmpmx,nec
    integer :: jlima0,jlimac,lontav,gd, nedit
    character(len=8) :: ctype
    cbid = dcmplx(0.d0, 0.d0)
   
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    keywordfact = 'RELA_CINE_BP'
    call getfac(keywordfact, nliai)
    if (nliai .eq. 0) goto 999
!
! - Initializations
!
    list_node = '&&CAPREC.LIST_NODE'
    list_rela = '&&CAPREC.RLLISTE'
    list_cabl = '&&CAPREC.LIST_CABL'
    list_anc1 = '&&CAPREC.LIST_ANC1'
    list_anc2 = '&&CAPREC.LIST_ANC2'
    list_rela = '&&CAPREC.LIRELA'
    list_rela_tmp = '&&CAPREC.LIRELA_TMP'
    cabl_sigm = load//'.CHME.SIGIN'
    model = ligrmo(1:8)
    
!
    call wkvect('&&CAPREC.LCES', 'V V K16', nliai, jlces)
    call wkvect('&&CAPREC.LCESL', 'V V L', nliai, jll)
    call wkvect('&&CAPREC.LCESR', 'V V R', nliai, jlr)
    nbchs=0
!
    call dismoi('DIM_GEOM', model, 'MODELE', repi=ndimmo)
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi=nb_elem)
    if (.not.(ndimmo.eq.2.or.ndimmo.eq.3)) then
        call utmess('F', 'CHARGES2_6')
    endif
!
! - Initializations of types
!
    lagr_type = '12'
    ASSERT(vale_type.eq.'REEL')
!
! - Minimum distance
!
    dist = armin(mesh)
!
! - Information about DEPL_R  <GRANDEUR>
!
    nomg_depl = 'DEPL_R'
    call jeveuo(jexnom('&CATA.GD.NOMCMP', nomg_depl), 'L', j_cmp_depl)
    call jelira(jexnom('&CATA.GD.NOMCMP', nomg_depl), 'LONMAX', nb_cmp_depl, k8bid)
    call dismoi('NB_EC', nomg_depl, 'GRANDEUR', repi=nbec_depl)
    ASSERT(nbec_depl.le.10)
    call jeveuo(ligrmo//'.PRNM', 'L', jprnm)
!
! - Index in DEPL_R <GRANDEUR> for DX, DY, DZ, DRX, DRY, DRZ
!
    cmp_name = 'DX'
    cmp_index_dx = indik8(zk8(j_cmp_depl), cmp_name, 1, nb_cmp_depl)
    ASSERT(cmp_index_dx.gt.0)
    cmp_name = 'DY'
    cmp_index_dy = indik8(zk8(j_cmp_depl), cmp_name, 1, nb_cmp_depl)
    ASSERT(cmp_index_dy.gt.0)
    cmp_name = 'DZ'
    cmp_index_dz = indik8(zk8(j_cmp_depl), cmp_name, 1, nb_cmp_depl)
    ASSERT(cmp_index_dz.gt.0)
    cmp_name = 'DRX'
    cmp_index_drx = indik8(zk8(j_cmp_depl), cmp_name, 1, nb_cmp_depl)
    ASSERT(cmp_index_drx.gt.0)
    cmp_name = 'DRY'
    cmp_index_dry = indik8(zk8(j_cmp_depl), cmp_name, 1, nb_cmp_depl)
    ASSERT(cmp_index_dry.gt.0)
    cmp_name = 'DRZ'
    cmp_index_drz = indik8(zk8(j_cmp_depl), cmp_name, 1, nb_cmp_depl)
    ASSERT(cmp_index_drz.gt.0)
!
! - Information about SIEF_R  <GRANDEUR>
!
    nomg_sief = 'SIEF_R'
    call jeveuo(jexnom('&CATA.GD.NOMCMP', nomg_sief), 'L', j_cmp_sief)
    call jelira(jexnom('&CATA.GD.NOMCMP', nomg_sief), 'LONMAX', nb_cmp_sief, k8bid)
    call dismoi('NB_EC', nomg_sief, 'GRANDEUR', repi=nbec_sief)
    ASSERT(nbec_sief.le.10)
!
    call dismoi('TYPE_CHARGE', load, 'CHARGE', repk=typcha)
    if (typcha(1:4) .eq. 'MECA') then
        ligrch=load//'.CHME.LIGRE'
    else if (typcha(1:4).eq.'THER') then
        ligrch=load//'.CHTH.LIGRE'
    else if (typcha(1:4).eq.'ACOU') then
        ligrch=load//'.CHAC.LIGRE'
    endif
!
! - On procède en deux passes : 
!       - évaluation de la place nécessaire pour les cartes CMULT et CIMPO 
!         et allocation des cartes
!       - remplissage (appel de aflrch) 
!
    do pass = 1, 2
!
       if ( pass == 1 ) then 
! Nombre total de termes dans les relations linéaires 
       nbteli_total = 0
! Type des coefficients et du second membre des relations linéaires 
       typcoe=''
       typval=''
       else if (pass == 2 ) then 
          if ( nbteli_total > 0 ) then 
! --- VERIFICATION DE L'ADEQUATION DE LA TAILLE DU LIGREL DE
! --- CHARGE A SON AFFECTATION PAR LES MAILLES TARDIVES DUES
! --- AUX RELATIONS LINEAIRES
! --- SI LE LIGREL DE CHARGE N'EXISTE PAS, ON LE CREE
              call craglc(nbteli_total, ligrch)
!
! --- VERIFICATION DE L'ADEQUATION DE LA TAILLE DES CARTES
! --- .CMULT ET .CIMPO DE LA CHARGE A LEUR AFFECTATION
! --- PAR LES MAILLES TARDIVES DUES AUX RELATIONS LINEAIRES
! --- SI LES CARTES .CMULT ET .CIMPO N'EXISTENT PAS, ON
! --- LES CREE
              call cragch(nbteli_total, typcoe, typval, ligrch)
          endif
       endif 
!
      do iocc = 1, nliai
!
! ----- Minimum distance
!
        call getvr8(keywordfact, 'DIST_MIN', iocc=iocc, scal=dist_mini, nbret=n1)
        if (n1 .eq. 0) dist_mini = dist*1.d-3
!
! ----- Options
!
        call getvtx(keywordfact, 'SIGM_BPEL', iocc=iocc, scal=answer, nbret=ibid)
        l_sigm_bpel = (answer.eq.'OUI')
        call getvtx(keywordfact, 'RELA_CINE', iocc=iocc, scal=answer, nbret=ibid)
        l_rela_cine = (answer.eq.'OUI')
!
        if (l_sigm_bpel .or. l_rela_cine) then
!
            call getvid(keywordfact, 'CABLE_BP', iocc=iocc, scal=cabl_prec, nbret=ibid)
!
! --------- Linear relations
!
            if (l_rela_cine) then
                list_rela_old = cabl_prec//'.LIRELA'
                call jeexin(list_rela_old//'.RLNR', iret)
                if (iret .eq. 0) then
                    call utmess('F', 'CHARGES2_48', sk=cabl_prec)
                endif
!
! ------------- Get old linear relations
!
                call jeveuo(list_rela_old//'.RLNR', 'L', vi=rlnr)
                nbrela = rlnr(1)
                call jelibe(list_rela_old//'.RLNR')
                if (nbrela .gt. 0) then
                    if ( pass == 1 ) then 
!
! --- NOMBRE TOTAL DE TERMES IMPLIQUES DANS LES RELATIONS
! --- DE LA LISTE DE RELATIONS (SERT AU REDIMENSIONNEMENT
! --- DU LIGREL DE CHARGE ET DES CARTES .CMULT ET .CIMPO
! --- DE LA CHARGE)
                        call jeveuo(list_rela_old//'.RLPO', 'L', vi=rlpo)
                        nbteli=rlpo(nbrela)
                        nbteli_total=nbteli_total+nbteli
                        call jeveuo(list_rela_old//'.RLTC', 'L', vk8=rltc)
                        if (typcoe == '') then 
                            typcoe=rltc(1)(1:4)
                        else 
                            ASSERT(typcoe == rltc(1)(1:4))
                        endif
!
! --- TYPE DES VALEURS AU SECOND MEMBRE DES RELATIONS
                       call jeveuo(list_rela_old//'.RLTV', 'L', vk8=rltv)
                       if (typval == '') then 
                          typval=rltv(1)(1:4)
                       else
                          ASSERT( typval == rltv(1)(1:4))
                       endif 
                    else if ( pass == 2 ) then  
                        call copisd(' ', 'V', list_rela_old, list_rela_tmp)
                        l_prealloc=.true.
                        call aflrch(list_rela_tmp, load, 'NLIN', &
                                    l_preallocz = l_prealloc)                        
                    endif
                endif
!
! ------------  Get information about cables
!
                call char_rcbp_cabl(cabl_prec, list_cabl, list_anc1, list_anc2, nb_cabl,&
                                    nb_anc1, nb_anc2)
                call jeveuo(list_cabl, 'L', jlicabl)
                call jeveuo(list_anc1, 'L', jlianc1)
                call jeveuo(list_anc2, 'L', jlianc2)
!
! ------------- Set linear relations for cables
!
                nume_cabl0 = 0
                name_ancr = ' '
                do i_cabl = 1, nb_cabl
                    nume_cabl = zi(jlicabl-1+i_cabl)
                    name_anc1 = zk24(jlianc1-1+i_cabl)
                    name_anc2 = zk24(jlianc2-1+i_cabl)
                    if (nume_cabl .ne. nume_cabl0) then
                        nume_cabl0 = nume_cabl
                        do i_ancr = 1, 2
                            name_ancr = ' '
                            if (i_ancr .eq. 1) name_ancr = name_anc1
                            if (i_ancr .eq. 2) name_ancr = name_anc2
                            if (name_ancr .ne. ' ') then
!
! ------------------------------Get list of nodes for ancrage
!
                                call char_rcbp_lino(mesh, name_ancr, list_node, nb_node)
                                call jeveuo(list_node, 'L', jlino)
                                if (nb_node .eq. 1) then
                                    call utmess('I', 'CHARGES2_17')
                                    goto 140
                                endif
!
! ----------------------------- Set LIAISON_SOLIDE for ndim =2
!
                                if (ndimmo .eq. 2) then
!
! --------------------------------- Is any node has rotation dof ?
!
                                    l_rota_2d = .false.
                                    do i_no = 1, nb_node
                                        nume_node = zi(jlino+i_no-1)
                                        if (exisdg(&
                                            zi(jprnm-i_no+(nume_node-1)*nbec_depl+1),&
                                            cmp_index_drz&
                                            )) then
                                            l_rota_2d = .true.
                                            goto 110
                                        endif
                                    enddo
110                                 continue
!
! --------------------------------- Compute linear relations
!
                                    if (l_rota_2d) then
                                        call drz12d(mesh, ligrmo, vale_type, nb_node, list_node,&
                                                    cmp_index_drz, lagr_type, list_rela,&
                                                    nom_noeuds_tmp)
                                    else
                                        call solide_tran('2D',mesh, vale_type, dist_mini, nb_node,&
                                                         list_node, lagr_type, list_rela,&
                                                         nom_noeuds_tmp, dim)
                                    endif
!
! ----------------------------- Set LIAISON_SOLIDE for ndim = 3
!
                                else if (ndimmo.eq.3) then
!
! --------------------------------- Is any node has rotation dof ?
!
                                    l_rota_3d = .false.
                                    do i_no = 1, nb_node
                                        nume_node = zi(jlino+i_no-1)
                                        if (exisdg(&
                                            zi(jprnm-1+(nume_node-1)*nbec_depl+1),&
                                            cmp_index_drx&
                                            )&
                                            .and.&
                                            exisdg(&
                                            zi(jprnm-1+(nume_node-1)*nbec_depl+1),&
                                            cmp_index_dry&
                                            )&
                                            .and.&
                                            exisdg(&
                                            zi(jprnm-1+(nume_node-1)*nbec_depl+1),&
                                            cmp_index_drz&
                                            )) then
                                            l_rota_3d = .true.
                                            goto 120
                                        endif
                                    enddo
120                                 continue
!
! --------------------------------- Compute linear relations
!
                                    if (l_rota_3d) then
                                        call drz13d(mesh, ligrmo, vale_type, nb_node, list_node,&
                                                    cmp_index_dx, cmp_index_dy, cmp_index_dz,&
                                                    cmp_index_drx, cmp_index_dry, cmp_index_drz,&
                                                    lagr_type, list_rela, nom_noeuds_tmp)
                                    else
                                        
                                        call solide_tran('3D',mesh, vale_type, dist_mini, nb_node,&
                                                         list_node, lagr_type, list_rela,&
                                                         nom_noeuds_tmp, dim)
                                    endif
                                else
                                    ASSERT(.false.)
                                endif
                                call jedetr(list_node)
                                if ( pass == 1 ) then 
!
! --- NOMBRE TOTAL DE TERMES IMPLIQUES DANS LES RELATIONS
! --- DE LA LISTE DE RELATIONS (SERT AU REDIMENSIONNEMENT
! --- DU LIGREL DE CHARGE ET DES CARTES .CMULT ET .CIMPO
! --- DE LA CHARGE)
                                   call jeveuo(list_rela//'.RLNR', 'L', vi=rlnr)
                                   nbrela = rlnr(1)
                                   call jelibe(list_rela//'.RLNR')
                                   call jeveuo(list_rela//'.RLPO', 'L', vi=rlpo)
                                   nbteli=rlpo(nbrela)
                                   call jelibe(list_rela//'.RLPO')
                                   nbteli_total=nbteli_total+nbteli
                                   call jeveuo(list_rela//'.RLTC', 'L', vk8=rltc)
                                   if (typcoe == '') then 
                                      typcoe=rltc(1)(1:4)
                                   else 
                                      ASSERT(typcoe == rltc(1)(1:4))
                                   endif
                                   call jelibe(list_rela//'.RLTC')
!
! --- TYPE DES VALEURS AU SECOND MEMBRE DES RELATIONS
                                   call jeveuo(list_rela//'.RLTV', 'L', vk8=rltv)
                                   if (typval == '') then 
                                       typval=rltv(1)(1:4)
                                   else
                                       ASSERT( typval == rltv(1)(1:4))
                                   endif 
                                   call jelibe(list_rela//'.RLTV')
!  Destruction de list_rela, à nouveau créée à la seconde passe
                                   call detrsd('LISTE_RELA', list_rela)
!
                                else if ( pass == 2 ) then  
                                   l_prealloc=.true.
                                   call aflrch(list_rela, load, 'NLIN', elim='NON', &
                                            l_preallocz=l_prealloc)
                                endif
                            endif 
140                         continue
                        enddo
                    endif
                enddo
                call jedetr(list_cabl)
                call jedetr(list_anc1)
                call jedetr(list_anc2)
            endif
        endif
      enddo
!  Fin de la boucle sur les passes
    enddo  
!
!  Get and combine stresses 
!
    do pass = 1, 2 
      if ( pass == 1) then 
        sigmcmp(1:3)=  (/ '', '', ''/)
      endif
!  
      nma = 0 
!
      do iocc = 1, nliai
!
          call getvtx(keywordfact, 'SIGM_BPEL', iocc=iocc, scal=answer, nbret=ibid)
          l_sigm_bpel = (answer.eq.'OUI')
!
          if (l_sigm_bpel) then
!
              call getvid(keywordfact, 'CABLE_BP', iocc=iocc, scal=cabl_prec, nbret=ibid)
!
! --------- Get and combine stresses
!         
              call jeveuo( cabl_prec//'.SIGMACABLE.VALE', 'L', vr=sigmvale )
              call jelira( cabl_prec//'.SIGMACABLE.VALE', 'LONUTI', nbval ) 
              call jeveuo( cabl_prec//'.SIGMACABLE.NUMA', 'L', vi=sigmnuma )
              call jelira( cabl_prec//'.SIGMACABLE.NUMA', 'LONUTI', nbma ) 

              if ( pass == 1 ) then
                  call jeveuo( cabl_prec//'.SIGMACABLE.NCMP', 'L', vk8=ncmp )
                  call jelira( cabl_prec//'.SIGMACABLE.NCMP', 'LONUTI', nbcmp ) 
                  ASSERT(nbcmp==3)  
                  if ( ALL(sigmcmp == '')) then 
                     sigmcmp (1:3) = ncmp(1:3)
                   else
                     ASSERT( ALL(sigmcmp == ncmp) )
                  endif
              endif
!        
              do ima = 1, nbma
                  if ( sigmnuma( ima ) == 0 ) then 
                     exit
                  else
                     nma = nma + 1
                     if ( pass == 2 ) then 
                         numa=sigmnuma(ima)
                         iivale = (ima-1)*nbcmp+1
                         do icmp = 1, nbcmp
                             zr(jvalv-1+icmp) = sigmvale(iivale-1+icmp)
                         enddo
                         call nocart (carte=cabl_sigm, code=3, ncmp=nbcmp, mode='NUM',&
                             nma=1,limanu=[numa],&
                             rapide='OUI',jdesc=jdesc,jnoma=jnoma,&
                             jncmp=jncmp,jnoli=jnoli,&
                             jvale=jvale,jvalv=jvalv,jnocmp=jnocmp,&
                             ncmpmx=ncmpmx,nec=nec,ctype=ctype,&
                             jlima0=jlima0,jlimac=jlimac,lontav=lontav)
                      endif
                   endif
              enddo
        endif
      enddo
      if ( pass == 1 ) then 
          if (nma > 0 ) then
      !
      ! Création de la carte cabl_sigm 
           
           call alcart('G', cabl_sigm, mesh , 'SIEF_R') 
           call jelira(jexnom('&CATA.GD.NOMCMP', 'SIEF_R'), 'LONMAX', nsief)
           call jeveuo(jexnom('&CATA.GD.NOMCMP', 'SIEF_R'), 'L', jsief)
           call jeveuo(cabl_sigm//'.NCMP', 'E', jncmp)
           call jeveuo(cabl_sigm//'.VALV', 'E', jvalv)
           do icmp = 1, nsief
                 zk8(jncmp-1+icmp) = zk8(jsief+icmp-1)
                 zr(jvalv-1+icmp) = 0.0d0
           end do
           call nocart(cabl_sigm, 1, nsief)
           do icmp = 1,nbcmp
              zk8(jncmp-1+icmp)=sigmcmp(icmp)
           enddo
!
           call jeveuo(cabl_sigm//'.DESC', 'E', jdesc)
           call jeveuo(cabl_sigm//'.NOMA', 'E', jnoma)
           call jeveuo(cabl_sigm//'.NOLI', 'E', jnoli)
           call jeveuo(cabl_sigm//'.VALE', 'E', jvale)
           call jelira(cabl_sigm//'.VALV', 'TYPELONG', cval=ctype)
           call jeveuo(cabl_sigm//'.LIMA', 'E', jlima0)
           call jeveuo(jexatr(cabl_sigm//'.LIMA', 'LONCUM'), 'E', jlimac)
           call jelira(cabl_sigm//'.LIMA', 'LONT', lontav)
           gd = zi(jdesc-1+1)
           call jeveuo(jexnum('&CATA.GD.NOMCMP', gd), 'L', jnocmp)
           call jelira(jexnum('&CATA.GD.NOMCMP', gd), 'LONMAX', ncmpmx)
           nec = nbec(gd)
!
          endif
      else if ( pass == 2 ) then 
!  Finalisation de la carte cabl_sigm
          if ( nma > 0 ) then 
            nedit = zi(jdesc-1+3)
            call jeecra(cabl_sigm//'.LIMA','NUTIOC',ival= nedit)
            call tecart( cabl_sigm )
          endif 
      endif 
      !
   enddo
      !
!
!
999 continue
    call jedema()
end subroutine
